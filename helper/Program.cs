using ScanHelper;

const string AddinOrigin = "https://localhost:3000";
const string CorsPolicy = "AddinOnly";

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy(CorsPolicy, policy =>
        policy.WithOrigins(AddinOrigin)
              .WithMethods("GET", "POST")
              .AllowAnyHeader());
});

// Bind to loopback only — this service must never be reachable off-box.
builder.WebHost.UseUrls("http://127.0.0.1:7643");

var app = builder.Build();
app.UseCors(CorsPolicy);

app.MapGet("/health", () => Results.Ok(new { status = "ok" }));

app.MapPost("/scan", async () =>
{
    ScanResult? result;
    try
    {
        result = await WiaScanner.AcquireImageAsync();
    }
    catch (Exception ex)
    {
        return Results.Problem(detail: ex.Message, statusCode: 500, title: "Scan failed");
    }

    if (result is null)
    {
        return Results.StatusCode(409); // user cancelled the scan dialog
    }

    return Results.Ok(new
    {
        imageBase64 = Convert.ToBase64String(result.ImageBytes),
        mimeType = result.MimeType
    });
});

app.Run();
