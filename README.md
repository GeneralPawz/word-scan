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

Ladet `word-scan-setup-<version>.exe` von der [neuesten Version](https://github.com/GeneralPawz/word-scan/releases/latest)
herunter und führt es aus. Das Setup

- installiert den Scan-Helfer (spricht mit eurem Scanner) unter `%LocalAppData%\Programs\WordScan`,
- trägt das Add-in bei Word automatisch ein — kein Trust-Center, kein Zertifikat, kein
  "Eigenes Add-In hochladen"-Dialog nötig,
- legt eine Verknüpfung im Startmenü an, optional auch im Autostart.

Danach nur noch **Word komplett schließen und neu öffnen** — im Reiter **Start** erscheint ein
**Scan**-Button.

> [!IMPORTANT]
> Der Helfer muss laufen, damit der Scan-Button funktioniert (das Setup startet ihn direkt; ohne
> Autostart-Option müsst ihr ihn danach über die Startmenü-Verknüpfung erneut öffnen). Passiert
> beim Klick nichts, prüft, ob sein Konsolenfenster noch offen ist.

> [!WARNING]
> Windows SmartScreen warnt eventuell vor dem Setup bzw. der Helfer-`.exe`, weil beide nicht
> signiert sind (Code-Signing kostet Geld, das dieses Hobbyprojekt nicht ausgibt). Klickt auf
> **Weitere Informationen → Trotzdem ausführen**. Der Quellcode liegt vollständig offen in diesem
> Repository — oder baut euch alles selbst, siehe [Selbst bauen](#selbst-bauen-️).

> [!NOTE]
> Euer Scanner muss bereits mit der in Windows eingebauten Scan-Funktion zusammenarbeiten (dieselbe,
> die **Windows-Fax und -Scan** oder die Fotos-App nutzt). Sieht die euren Scanner nicht, sieht ihn
> dieses Add-in auch nicht.

<details>
<summary>Manuelle Installation ohne Setup (fortgeschritten)</summary>

Alternativ liegen `word-scan-helper-<version>-win-x64.exe` und `word-scan-manifest.xml` einzeln im
selben Release. Startet die `.exe` manuell und tragt den Sideload-Registry-Schlüssel selbst ein
(`HKEY_CURRENT_USER\Software\Microsoft\Office\16.0\WEF\Developer`, Wertname
`e667ed5b-c1c6-4f76-a374-a3a71521431d`, Wert = Pfad zur `word-scan-manifest.xml`) — genau das, was
das Setup automatisch macht. Der Weg über Word selbst (Reiter **Datei** → **Optionen** (ganz unten)
→ **Add-Ins** → unten im Dropdown **Meine Add-Ins** wählen → **Eigenes Add-In hochladen**) funktioniert
nur mit einem Microsoft-365-Konto zuverlässig und meldet sonst gerne Schema- oder Zertifikatsfehler.

</details>

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
