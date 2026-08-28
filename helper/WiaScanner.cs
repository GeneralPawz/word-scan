using System.Runtime.InteropServices;

namespace ScanHelper;

public sealed record ScanResult(byte[] ImageBytes, string MimeType);

/// <summary>
/// Late-bound COM wrapper around the WIA Automation Layer (wiaaut.dll, "WIA.CommonDialog").
/// Late binding avoids needing a COM type-library reference at build time.
/// </summary>
public static class WiaScanner
{
    // WIA Automation Layer constants (from wiaaut.h) — not exposed without a type-lib reference.
    private const int ScannerDeviceType = 1;
    private const int ColorIntent = 1;
    private const int MaximizeQuality = 0x20000;
    private const string WiaFormatPNG = "{B96B3CAF-0728-11D3-9D7B-0000F81EF32E}";

    public static Task<ScanResult?> AcquireImageAsync()
    {
        var tcs = new TaskCompletionSource<ScanResult?>();

        var thread = new Thread(() =>
        {
            try
            {
                tcs.SetResult(AcquireImage());
            }
            catch (Exception ex)
            {
                tcs.SetException(ex);
            }
        });

        // WIA's common dialog shows UI and must run on an STA thread.
        thread.SetApartmentState(ApartmentState.STA);
        thread.IsBackground = true;
        thread.Start();

        return tcs.Task;
    }

    private static ScanResult? AcquireImage()
    {
        var dialogType = Type.GetTypeFromProgID("WIA.CommonDialog")
            ?? throw new InvalidOperationException(
                "WIA.CommonDialog is not registered on this machine. Windows Image Acquisition must be available.");

        dynamic dialog = Activator.CreateInstance(dialogType)!;
        try
        {
            // ShowAcquireImage(DeviceType, Intent, Bias, FormatID, AlwaysSelectDevice, UseCommonUI, CancelError)
            // CancelError=false => returns null instead of throwing when the user cancels.
            dynamic? imageFile = dialog.ShowAcquireImage(
                ScannerDeviceType,
                ColorIntent,
                MaximizeQuality,
                WiaFormatPNG,
                false,
                true,
                false);

            if (imageFile is null)
            {
                return null; // user cancelled or no scanner selected
            }

            var tempPath = Path.Combine(Path.GetTempPath(), $"word-scan-{Guid.NewGuid():N}.png");
            try
            {
                imageFile.SaveFile(tempPath);
                var bytes = File.ReadAllBytes(tempPath);
                return new ScanResult(bytes, "image/png");
            }
            finally
            {
                if (File.Exists(tempPath))
                {
                    File.Delete(tempPath);
                }
                Marshal.FinalReleaseComObject(imageFile);
            }
        }
        finally
        {
            Marshal.FinalReleaseComObject(dialog);
        }
    }
}
