# <img src="assets/icon-128.png" width="28" align="top" alt=""> Word Scan

🇩🇪 [Deutsch](README.md) · 🇬🇧 English (this page)

[![Latest release](https://img.shields.io/github/v/release/GeneralPawz/word-scan?style=flat-square&logo=github&label=release)](https://github.com/GeneralPawz/word-scan/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/GeneralPawz/word-scan/total?style=flat-square&label=downloads)](https://github.com/GeneralPawz/word-scan/releases)
[![CI](https://img.shields.io/github/actions/workflow/status/GeneralPawz/word-scan/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/GeneralPawz/word-scan/actions/workflows/ci.yml)
[![Licence MIT](https://img.shields.io/badge/licence-MIT-blue?style=flat-square)](LICENSE)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ff69b4?style=flat-square&logo=githubsponsors)](https://github.com/sponsors/GeneralPawz)

Scan a document with your scanner and drop the image straight into Word, right where your cursor
is — no scanning app, no saving a file, no "Insert Picture" dialog.

## Install 🚀

You need **two things**, both from the [latest release](https://github.com/GeneralPawz/word-scan/releases/latest):

1. **The scan helper** — `word-scan-helper-<version>-win-x64.exe`. This talks to your scanner. Save it
   anywhere (e.g. `Documents\WordScan\`) and double-click it whenever you want to scan; a console
   window stays open while it runs.
2. **The add-in** — `word-scan-manifest.xml`. In Word: **Insert** tab → **Add-ins** → **My Add-ins**
   → **Upload My Add-in** → pick the downloaded `word-scan-manifest.xml`. A **Scan** button appears
   on the **Home** tab from then on, in every document.

> [!IMPORTANT]
> The helper must be running for the Scan button to work. If clicking Scan does nothing, check
> that its console window is still open.

> [!WARNING]
> Windows SmartScreen may warn about the helper `.exe` because it isn't code-signed (signing costs
> money this hobby project doesn't spend). Click **More info → Run anyway**. The source is fully
> open in this repository if you'd like to check it yourself — or build it from source instead,
> see [Building from source](#building-from-source-).

> [!NOTE]
> Your scanner needs to already work with Windows' built-in scanning (the same one **Windows Fax
> and Scan** or the Photos app uses). If that doesn't see your scanner, this add-in won't either.

## Using it 🖨️

1. Click into your document where the scanned image should go.
2. Open the **Scan** task pane (Home tab) and click **Scan**.
3. Your system's scan dialog opens — pick a device/settings if it asks.
4. The scanned image lands inline right where your cursor was — clicking into the task pane
   doesn't move it.

## Building from source 🛠️

For contributors, or if you'd rather build the helper yourself instead of trusting the release
binary — see [CONTRIBUTING.md](CONTRIBUTING.md) for the full dev setup (`.NET 8 SDK` + `Node.js`
required).

## Requirements 📋

- Windows, with a scanner that already works via Windows' built-in scan support (WIA)
- Desktop Word (Microsoft 365 or Word 2016+)

## How it fits together 🔍

- The add-in itself (HTML/CSS/JS) is hosted on GitHub Pages — no install beyond the manifest file.
- Since browser-sandboxed add-ins can't talk to scanner hardware directly, a small local helper
  service (`.NET`, self-contained, no separate runtime install) does the actual WIA scanning and
  hands the image back over `127.0.0.1` only — it's never reachable from outside your machine.

## Limitations 📎

- Windows desktop Word only — WIA and the local helper are Windows-specific.
- The helper isn't code-signed; see the SmartScreen note above.

## Sponsoring 💸

Word Scan is free and always will be. If it saved you a trip to a scanning app and you'd like to
send something back, [sponsorship is welcome](https://github.com/sponsors/GeneralPawz) and
entirely optional. Bug reports and pull requests are worth just as much — see
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © Friedrich Schrödter
