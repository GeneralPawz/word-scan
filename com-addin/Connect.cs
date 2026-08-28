using System;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using Extensibility;

namespace WordScanAddin
{
    [ComVisible(true)]
    [Guid("A1B2C3D4-5E6F-4A7B-8C9D-0E1F2A3B4C5D")]
    // AutoDual so Word can resolve the ribbon callbacks (GetButtonImage/OnScanClick), which it
    // invokes late-bound by name off the add-in object rather than through a declared interface.
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId(ProgIdValue)]
    public sealed class Connect : IDTExtensibility2, Microsoft.Office.Core.IRibbonExtensibility
    {
        public const string ProgIdValue = "WordScanAddin.Connect";

        private dynamic _wordApp;

        public Connect()
        {
            Log("Connect() constructed");
        }

        public void OnConnection(object Application, ext_ConnectMode ConnectMode, object AddInInst, ref Array custom)
        {
            try
            {
                _wordApp = Application;
                Log("OnConnection OK, ConnectMode=" + ConnectMode);
            }
            catch (Exception ex)
            {
                Log("OnConnection FAILED: " + ex);
                throw;
            }
        }

        internal static void Log(string message)
        {
            try
            {
                var path = Path.Combine(Path.GetTempPath(), "word-scan-addin.log");
                File.AppendAllText(path, DateTime.Now.ToString("O") + " " + message + Environment.NewLine);
            }
            catch
            {
                // logging must never throw
            }
        }

        public void OnDisconnection(ext_DisconnectMode RemoveMode, ref Array custom)
        {
            _wordApp = null;
        }

        public void OnAddInsUpdate(ref Array custom) { }
        public void OnStartupComplete(ref Array custom) { }
        public void OnBeginShutdown(ref Array custom) { }

        public string GetCustomUI(string RibbonID)
        {
            try
            {
                Log("GetCustomUI called, RibbonID=" + RibbonID);
                return RibbonXml.Markup;
            }
            catch (Exception ex)
            {
                Log("GetCustomUI FAILED: " + ex);
                throw;
            }
        }

        // Ribbon callbacks below are invoked late-bound by name; parameters are declared as
        // plain `object` so no Office PIA / IRibbonControl type reference is needed.

        public object GetButtonImage(object control)
        {
            try
            {
                using (var stream = Assembly.GetExecutingAssembly()
                           .GetManifestResourceStream("WordScanAddin.icon-32.png"))
                {
                    if (stream == null)
                    {
                        Log("GetButtonImage: embedded icon resource not found");
                        return null;
                    }

                    // The Image is handed to COM as an IPictureDisp, so it must not be disposed here.
                    return PictureDispConverter.ToIPictureDisp(Image.FromStream(stream));
                }
            }
            catch (Exception ex)
            {
                // A failed icon must never take the whole button down.
                Log("GetButtonImage FAILED: " + ex);
                return null;
            }
        }

        public void OnScanClick(object control)
        {
            if (_wordApp == null)
            {
                return;
            }

            ScanResult scan;
            try
            {
                scan = WiaScanner.AcquireImage();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Scan failed: " + ex.Message, "Word Scan", MessageBoxButtons.OK, MessageBoxIcon.Error);
                return;
            }

            if (scan == null)
            {
                return; // user cancelled the scan dialog
            }

            var tempPath = Path.Combine(Path.GetTempPath(), "word-scan-insert-" + Guid.NewGuid().ToString("N") + ".png");
            try
            {
                File.WriteAllBytes(tempPath, scan.ImageBytes);

                dynamic selection = _wordApp.Selection;
                dynamic range = selection.Range;
                range.InlineShapes.AddPicture(tempPath, false, true, Type.Missing);
            }
            finally
            {
                if (File.Exists(tempPath))
                {
                    File.Delete(tempPath);
                }
            }
        }

        private sealed class PictureDispConverter : AxHost
        {
            private PictureDispConverter() : base(string.Empty) { }

            public static object ToIPictureDisp(Image image)
            {
                return GetIPictureDispFromPicture(image);
            }
        }
    }
}
