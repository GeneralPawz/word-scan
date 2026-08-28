; Word Scan installer.
;
; Installs the scan helper and sideloads the Word add-in via the officially supported
; per-user "WEF\Developer" registry key (see Microsoft's docs on sideloading Office
; Add-ins on Windows for testing). This avoids the Trust Center / Trusted Catalog /
; "Upload My Add-in" flow entirely — no manifest path to click through in Word, no
; certificate to trust, no M365-managed account required.
;
; Expects, relative to this .iss file's directory, an "input" folder containing:
;   input\ScanHelper.exe   — the published self-contained helper
;   input\manifest.xml     — the production manifest (GitHub Pages URLs)
;
; Build locally with Inno Setup 6: ISCC installer\word-scan.iss /DMyAppVersion=0.1.0
; (MyAppVersion defaults to 0.0.0-dev when not passed, for local test compiles.)

#ifndef MyAppVersion
  #define MyAppVersion "0.0.0-dev"
#endif

#define MyAppName "Word Scan"
#define MyAppId "e667ed5b-c1c6-4f76-a374-a3a71521431d"

[Setup]
AppId={{A6F1E9C2-6B0B-4C7E-9C63-CB2E7F5C9D41}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher=Friedrich Schroedter
AppPublisherURL=https://github.com/GeneralPawz/word-scan
DefaultDirName={localappdata}\Programs\WordScan
DefaultGroupName=Word Scan
DisableProgramGroupPage=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
OutputDir=..\dist
OutputBaseFilename=word-scan-setup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\ScanHelper.exe
SetupIconFile=..\assets\icon-128.ico

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
english.RestartWordNotice=Please fully close Word (all windows) and reopen it. A "Scan" button will then appear on the Home tab.%n%nThe scan helper is running now (look for its console window) and needs to keep running whenever you want to scan.
german.RestartWordNotice=Bitte schließt Word vollständig (alle Fenster) und öffnet es neu. Im Reiter "Start" erscheint dann ein "Scan"-Button.%n%nDer Scan-Helfer läuft jetzt (sein Konsolenfenster ist offen) und muss laufen, sobald ihr scannen möchtet.
english.StartupTask=Start the scan helper automatically when I sign in
german.StartupTask=Scan-Helfer automatisch bei der Windows-Anmeldung starten
english.RunHelperAfter=Start the scan helper now
german.RunHelperAfter=Scan-Helfer jetzt starten

[Tasks]
Name: "startupshortcut"; Description: "{cm:StartupTask}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "input\ScanHelper.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "input\manifest.xml"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\Word Scan Helfer"; Filename: "{app}\ScanHelper.exe"
Name: "{userstartup}\Word Scan Helfer"; Filename: "{app}\ScanHelper.exe"; Tasks: startupshortcut

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Office\16.0\WEF\Developer"; ValueType: string; \
  ValueName: "{#MyAppId}"; ValueData: "{app}\manifest.xml"; Flags: uninsdeletevalue

[Run]
Filename: "{app}\ScanHelper.exe"; Description: "{cm:RunHelperAfter}"; Flags: nowait postinstall skipifsilent runasoriginaluser

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    MsgBox(ExpandConstant('{cm:RestartWordNotice}'), mbInformation, MB_OK);
  end;
end;
