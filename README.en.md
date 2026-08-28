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

**Close Word**, then download `word-scan-setup-<version>.exe` from the
[latest release](https://github.com/GeneralPawz/word-scan/releases/latest) and run it. The
installer sets everything up and registers the add-in with Word — no Trust Center, no
certificate, no admin rights needed.

Then open Word: a **Scan** button appears on the **Home** tab. That's it.

> [!IMPORTANT]
> Word must be closed while installing — it otherwise holds a lock on the add-in file.

> [!WARNING]
> Windows SmartScreen may warn about the installer because it isn't code-signed (signing costs
> money this hobby project doesn't spend). Click **More info → Run anyway**. The source is fully
> open in this repository if you'd like to check it yourself — or build it from source instead,
> see [Building from source](#building-from-source-).

> [!NOTE]
> Your scanner needs to already work with Windows' built-in scanning (the same one **Windows Fax
> and Scan** or the Photos app uses). If that doesn't see your scanner, this add-in won't either.

## Using it 🖨️

1. Click into your document where the scanned image should go.
2. Click **Scan** on the **Home** tab.
3. Your system's scan dialog opens — pick a device/settings if it asks.
4. The scanned image lands inline right where your cursor was.

## Building from source 🛠️

For contributors, or if you'd rather not trust the release build — see
[CONTRIBUTING.md](CONTRIBUTING.md) for the full dev setup (only the `.NET SDK` is required).

## Requirements 📋

- Windows, with a scanner that already works via Windows' built-in scan support (WIA)
- Desktop Word (Microsoft 365 or Word 2016+)
- .NET Framework 4.8 (already present on current Windows installs)

## How it works 🔍

Word Scan is a classic COM add-in (.NET Framework) running inside Word itself. The Scan button
calls Windows Image Acquisition (WIA) and inserts the result at the cursor through Word's own
object model — all in one process, with no background service, local server, or network access.

Registration is entirely per-user under `HKEY_CURRENT_USER`, which is why the installer needs no
admin rights.

> [!NOTE]
> This started out as a modern Office.js add-in. That turned out to be uninstallable on machines
> carrying an enterprise identity (Azure AD workplace join), where uploading custom add-ins is
> blocked. Classic COM add-ins aren't subject to that restriction.

## Limitations 📎

- Windows desktop Word only — WIA and COM add-ins are Windows-specific.
- The installer isn't code-signed; see the SmartScreen note above.

## Sponsoring 💸

Word Scan is free and always will be. If it saved you a trip to a scanning app and you'd like to
send something back, [sponsorship is welcome](https://github.com/sponsors/GeneralPawz) and
entirely optional. Bug reports and pull requests are worth just as much — see
[CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE) © Friedrich Schrödter
