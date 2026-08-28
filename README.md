# <img src="assets/icon-128.png" width="28" align="top" alt=""> Word Scan

🇩🇪 Deutsch (diese Seite) · 🇬🇧 [English](README.en.md)

[![Neueste Version](https://img.shields.io/github/v/release/GeneralPawz/word-scan?style=flat-square&logo=github&label=release)](https://github.com/GeneralPawz/word-scan/releases/latest)
[![Downloads](https://img.shields.io/github/downloads/GeneralPawz/word-scan/total?style=flat-square&label=downloads)](https://github.com/GeneralPawz/word-scan/releases)
[![CI](https://img.shields.io/github/actions/workflow/status/GeneralPawz/word-scan/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/GeneralPawz/word-scan/actions/workflows/ci.yml)
[![Lizenz MIT](https://img.shields.io/badge/lizenz-MIT-blue?style=flat-square)](LICENSE)
[![Sponsor](https://img.shields.io/badge/sponsor-%E2%99%A5-ff69b4?style=flat-square&logo=githubsponsors)](https://github.com/sponsors/GeneralPawz)

Scannt ein Dokument mit eurem Scanner und fügt das Bild direkt in Word ein — genau dort, wo der
Cursor gerade steht. Keine separate Scan-App, kein Zwischenspeichern, kein "Grafik einfügen"-Dialog.

> [!NOTE]
> Diese README ist standardmäßig auf Deutsch. GitHub kann Dateien nicht automatisch je nach
> Browsersprache anzeigen — dafür gibt's oben den Link zur [englischen Version](README.en.md).

## Installation 🚀

Ihr braucht **zwei Dateien** von der [neuesten Version](https://github.com/GeneralPawz/word-scan/releases/latest):

1. **Den Scan-Helfer** — `word-scan-helper-<version>-win-x64.exe`. Er spricht mit eurem Scanner.
   Speichert ihn irgendwo ab (z. B. `Dokumente\WordScan\`) und startet ihn per Doppelklick, sobald
   ihr scannen wollt; dabei bleibt ein Konsolenfenster geöffnet.
2. **Das Add-in** — `word-scan-manifest.xml`. In Word: Reiter **Einfügen** → **Add-Ins** →
   **Meine Add-Ins** → **Eigenes Add-In hochladen** → die heruntergeladene `word-scan-manifest.xml`
   auswählen. Ab dann erscheint in jedem Dokument ein **Scan**-Button im Reiter **Start**.

> [!IMPORTANT]
> Der Helfer muss laufen, damit der Scan-Button funktioniert. Passiert beim Klick nichts, prüft,
> ob sein Konsolenfenster noch offen ist.

> [!WARNING]
> Windows SmartScreen warnt eventuell vor der Helfer-`.exe`, weil sie nicht signiert ist (Code-
> Signing kostet Geld, das dieses Hobbyprojekt nicht ausgibt). Klickt auf **Weitere Informationen
> → Trotzdem ausführen**. Der Quellcode liegt vollständig offen in diesem Repository — oder baut
> euch den Helfer einfach selbst, siehe [Selbst bauen](#selbst-bauen-️).

> [!NOTE]
> Euer Scanner muss bereits mit der in Windows eingebauten Scan-Funktion zusammenarbeiten (dieselbe,
> die **Windows-Fax und -Scan** oder die Fotos-App nutzt). Sieht die euren Scanner nicht, sieht ihn
> dieses Add-in auch nicht.

## Benutzung 🖨️

1. Klickt im Dokument an die Stelle, an die das gescannte Bild soll.
2. Öffnet den **Scan**-Taskbereich (Reiter Start) und klickt auf **Scan**.
3. Der Scan-Dialog eures Systems öffnet sich — wählt bei Bedarf Gerät/Einstellungen.
4. Das gescannte Bild landet genau dort, wo euer Cursor stand — ein Klick in den Taskbereich
   verschiebt ihn nicht.

## Selbst bauen 🛠️

Für Mitwirkende, oder wenn ihr den Helfer lieber selbst bauen statt der Release-Binary vertrauen
wollt — das komplette Dev-Setup (benötigt `.NET 8 SDK` + `Node.js`) steht in
[CONTRIBUTING.md](CONTRIBUTING.md) (auf Englisch).

## Voraussetzungen 📋

- Windows, mit einem Scanner, der bereits über die eingebaute Windows-Scan-Unterstützung (WIA)
  funktioniert
- Word als Desktop-Anwendung (Microsoft 365 oder Word 2016+)

## Wie es zusammenspielt 🔍

- Das Add-in selbst (HTML/CSS/JS) liegt auf GitHub Pages — es muss außer der Manifest-Datei nichts
  installiert werden.
- Da im Browser-Sandkasten laufende Add-ins nicht direkt mit Scanner-Hardware sprechen können,
  übernimmt ein kleiner lokaler Helfer-Dienst (.NET, eigenständig, keine separate Runtime nötig)
  das eigentliche WIA-Scannen und gibt das Bild ausschließlich über `127.0.0.1` zurück — von
  außerhalb eures Rechners ist er nie erreichbar.

## Einschränkungen 📎

- Nur Word als Desktop-Anwendung unter Windows — WIA und der lokale Helfer sind Windows-spezifisch.
- Der Helfer ist nicht code-signiert; siehe die SmartScreen-Warnung oben.

## Unterstützung 💸

Word Scan ist kostenlos und bleibt es auch. Wenn es euch den Weg zu einer Scan-App erspart hat und
ihr etwas zurückgeben möchtet, ist [Sponsoring willkommen](https://github.com/sponsors/GeneralPawz)
— völlig freiwillig. Bug-Reports und Pull Requests sind genauso viel wert — siehe
[CONTRIBUTING.md](CONTRIBUTING.md).

## Lizenz

[MIT](LICENSE) © Friedrich Schrödter
