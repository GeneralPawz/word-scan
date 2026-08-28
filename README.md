# Word Scan

A Word add-in that lets you scan a document directly from your system scanner and insert
the image at your cursor position, without leaving Word.

Two components:

- **`helper/`** — a small local ASP.NET Core service (`ScanHelper`) that talks to your
  scanner via the Windows Image Acquisition (WIA) API and exposes it over
  `http://127.0.0.1:7643`, loopback-only.
- **`addin/`** — the Word task pane add-in (HTML/CSS/JS via Office.js). Its "Scan" button
  calls the helper, then inserts the returned image as an inline picture at your last
  cursor position in the document.

## Prerequisites

- Windows, with a scanner installed and working via Windows' built-in scanner support (WIA)
- [.NET SDK 8](https://dotnet.microsoft.com/download) or later
- [Node.js](https://nodejs.org/) 18+
- Desktop Word (Microsoft 365 or Word 2016+)

## Running it

1. **Start the scan helper** (keep this running in the background whenever you want to scan):

   ```
   cd helper
   dotnet run
   ```

   Verify it's up: `curl http://127.0.0.1:7643/health` should return `{"status":"ok"}`.

2. **Install the add-in's dev dependencies and trusted local HTTPS cert** (first time only):

   ```
   cd addin
   npm install
   npx office-addin-dev-certs install
   ```

3. **Start the add-in's dev server**:

   ```
   npm start
   ```

   This serves the task pane at `https://localhost:3000`.

4. **Sideload the add-in into Word**:

   ```
   npm run sideload
   ```

   This opens Word and loads the add-in from `manifest.xml`. A "Scan" button appears
   on the Home ribbon tab.

## Using it

1. Click into your document where you want the scanned image to go.
2. Open the Scan task pane and click **Scan**.
3. Your system's scan dialog opens — pick a device/settings if prompted.
4. The scanned image is inserted inline at the cursor position you had before opening
   the task pane (clicking into the task pane doesn't move your document cursor).

## Notes / limitations

- Desktop Windows Word only (WIA and the local helper are Windows-specific).
- The helper binds to `127.0.0.1` only and only accepts requests from the add-in's
  dev origin (`https://localhost:3000`) via CORS — it isn't reachable from other
  machines or arbitrary web pages.
- For production distribution, replace `manifest.xml`'s `localhost:3000` URLs with a
  real hosted origin, and package/install the helper as a startup service instead of
  running it manually via `dotnet run`.
