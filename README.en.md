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

Download `word-scan-setup-<version>.exe` from the [latest release](https://github.com/GeneralPawz/word-scan/releases/latest)
and run it. The installer

- installs the scan helper (talks to your scanner) under `%LocalAppData%\Programs\WordScan`,
- registers the add-in with Word automatically — no Trust Center, no certificate, no
  "Upload My Add-in" dialog needed,
- adds a Start Menu shortcut, and optionally a startup-on-login shortcut.

Then just **fully close and reopen Word** — a **Scan** button appears on the **Home** tab.

> [!IMPORTANT]
> The helper must be running for the Scan button to work (the installer starts it right away;
> without the autostart option you'll need to relaunch it from the Start Menu shortcut after that).
> If clicking Scan does nothing, check that its console window is still open.

> [!WARNING]
> Windows SmartScreen may warn about the installer or the helper `.exe` because neither is
> code-signed (signing costs money this hobby project doesn't spend). Click **More info → Run
> anyway**. The source is fully open in this repository if you'd like to check it yourself — or
> build everything from source instead, see [Building from source](#building-from-source-).

> [!NOTE]
> Your scanner needs to already work with Windows' built-in scanning (the same one **Windows Fax
> and Scan** or the Photos app uses). If that doesn't see your scanner, this add-in won't either.

<details>
<summary>Manual install without the setup (advanced)</summary>

`word-scan-helper-<version>-win-x64.exe` and `word-scan-manifest.xml` are also available
individually in the same release. Run the `.exe` yourself and add the sideload registry key the
installer would otherwise set for you (`HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\WEF\Developer`,
value name `e667ed5b-c1c6-4f76-a374-a3a71521431d`, value = path to `word-scan-manifest.xml`).
**Upload My Add-in** only reliably works with a Microsoft 365 account and otherwise tends to report
schema or certificate errors instead.

</details>

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
