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

**Word schließen**, dann `word-scan-setup-<version>.exe` von der
[neuesten Version](https://github.com/GeneralPawz/word-scan/releases/latest) herunterladen und
ausführen. Das Setup installiert alles und trägt das Add-In bei Word ein — kein Trust-Center, kein
Zertifikat, keine Administratorrechte nötig.

Danach Word öffnen: im Reiter **Start** erscheint ein **Scan**-Button. Das war's.

> [!IMPORTANT]
> Word muss beim Installieren geschlossen sein — es hält sonst die Add-In-Datei gesperrt.

> [!WARNING]
> Windows SmartScreen warnt eventuell vor dem Setup, weil es nicht signiert ist (Code-Signing
> kostet Geld, das dieses Hobbyprojekt nicht ausgibt). Klickt auf **Weitere Informationen →
> Trotzdem ausführen**. Der Quellcode liegt vollständig offen in diesem Repository — oder baut
> euch alles selbst, siehe [Selbst bauen](#selbst-bauen-️).

> [!NOTE]
> Euer Scanner muss bereits mit der in Windows eingebauten Scan-Funktion zusammenarbeiten (dieselbe,
> die **Windows-Fax und -Scan** oder die Fotos-App nutzt). Sieht die euren Scanner nicht, sieht ihn
> dieses Add-in auch nicht.

## Benutzung 🖨️

1. Klickt im Dokument an die Stelle, an die das gescannte Bild soll.
2. Klickt im Reiter **Start** auf **Scan**.
3. Der Scan-Dialog eures Systems öffnet sich — wählt bei Bedarf Gerät/Einstellungen.
4. Das gescannte Bild landet genau dort, wo euer Cursor stand.

## Selbst bauen 🛠️

Für Mitwirkende, oder wenn ihr dem Release-Build lieber nicht vertrauen wollt — das komplette
Dev-Setup (benötigt nur das `.NET SDK`) steht in [CONTRIBUTING.md](CONTRIBUTING.md) (auf Englisch).

## Voraussetzungen 📋

- Windows, mit einem Scanner, der bereits über die eingebaute Windows-Scan-Unterstützung (WIA)
  funktioniert
- Word als Desktop-Anwendung (Microsoft 365 oder Word 2016+)
- .NET Framework 4.8 (auf aktuellen Windows-Installationen bereits vorhanden)

## Wie es funktioniert 🔍

Word Scan ist ein klassisches COM-Add-In (.NET Framework), das direkt in Word läuft. Der
Scan-Button ruft Windows Image Acquisition (WIA) auf und fügt das Ergebnis über Words eigenes
Objektmodell an der Cursorposition ein — alles in einem Prozess, ohne Hintergrunddienst,
lokalen Server oder Netzwerkzugriff.

Die Registrierung erfolgt vollständig benutzerbezogen unter `HKEY_CURRENT_USER`, weshalb das
Setup ohne Administratorrechte auskommt.

> [!NOTE]
> Der ursprüngliche Ansatz war ein modernes Office.js-Add-In. Der ließ sich auf Rechnern mit
> Unternehmens-Identität (Azure AD Workplace Join) nicht installieren — das Hochladen eigener
> Add-Ins ist dort gesperrt. Klassische COM-Add-Ins sind davon nicht betroffen.

## Einschränkungen 📎

- Nur Word als Desktop-Anwendung unter Windows — WIA und COM-Add-Ins sind Windows-spezifisch.
- Das Setup ist nicht code-signiert; siehe die SmartScreen-Warnung oben.

## Unterstützung 💸

Word Scan ist kostenlos und bleibt es auch. Wenn es euch den Weg zu einer Scan-App erspart hat und
ihr etwas zurückgeben möchtet, ist [Sponsoring willkommen](https://github.com/sponsors/GeneralPawz)
— völlig freiwillig. Bug-Reports und Pull Requests sind genauso viel wert — siehe
[CONTRIBUTING.md](CONTRIBUTING.md).

## Lizenz

[MIT](LICENSE) © Friedrich Schrödter
