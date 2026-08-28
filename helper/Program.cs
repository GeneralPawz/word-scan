using ScanHelper;

// Local dev server and the GitHub Pages-hosted production add-in — both need to reach this
// loopback-only helper from the browser/WebView2 that's rendering the task pane.
var AddinOrigins = new[]
{
    "https://localhost:3000",
    "https://generalpawz.github.io",
};
const string CorsPolicy = "AddinOnly";

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy(CorsPolicy, policy =>
        policy.WithOrigins(AddinOrigins)
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
