; Word Scan installer.
;
; Installs a managed COM add-in for Word. Registration is entirely per-user under HKCU, so
; no admin rights are needed and regasm is never invoked: the [Registry] section below writes
; exactly the keys regasm /codebase would have written, plus Word's own Addins entry.
;
; Classic COM add-in loading (HKCU\Software\Microsoft\Office\Word\Addins) is used rather than
; the modern Office Add-ins / WEF sideload, because the latter is blocked on machines carrying
; an enterprise workplace-join identity, which is what this project originally ran aground on.
;
; Expects, relative to this .iss file's directory, an "input" folder containing:
;   input\WordScanAddin.dll — the built net48 COM add-in
;
; Build locally with Inno Setup 6: ISCC installer\word-scan.iss /DMyAppVersion=0.3.0
; (MyAppVersion defaults to 0.0.0-dev when not passed, for local test compiles.)

#ifndef MyAppVersion
  #define MyAppVersion "0.0.0-dev"
#endif

#define MyAppName "Word Scan"
#define AddinProgId "WordScanAddin.Connect"
#define AddinClsid "{{A1B2C3D4-5E6F-4A7B-8C9D-0E1F2A3B4C5D}"
#define AddinAssembly "WordScanAddin, Version=1.0.0.0, Culture=neutral, PublicKeyToken=null"

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
; Install in 64-bit mode so the COM registration lands in the real HKCU\Software\Classes\CLSID.
; Without this the installer runs 32-bit and WOW64 silently redirects those writes into
; Wow6432Node, where 64-bit Word never looks — the add-in then just never appears.
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..\dist
OutputBaseFilename=word-scan-setup-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\WordScanAddin.dll
SetupIconFile=..\assets\icon-128.ico

[Languages]
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "english"; MessagesFile: "compiler:Default.isl"

[CustomMessages]
english.RestartWordNotice=Please fully close Word (all windows) and reopen it. A "Scan" button then appears on the Home tab.
german.RestartWordNotice=Bitte schließt Word vollständig (alle Fenster) und öffnet es neu. Im Reiter "Start" erscheint dann ein "Scan"-Button.
english.WordRunningWarning=Word appears to be running. Please close it before continuing, otherwise the add-in cannot be installed.
german.WordRunningWarning=Word läuft anscheinend noch. Bitte schließt es, bevor ihr fortfahrt, sonst kann das Add-In nicht installiert werden.

[Files]
Source: "input\WordScanAddin.dll"; DestDir: "{app}"; Flags: ignoreversion

[InstallDelete]
; Leftovers from the pre-0.3 helper-service/Office.js layout.
Type: filesandordirs; Name: "{app}\catalog"
Type: files; Name: "{app}\ScanHelper.exe"
Type: files; Name: "{app}\manifest.xml"
Type: files; Name: "{group}\Word Scan Helfer.lnk"
Type: files; Name: "{userstartup}\Word Scan Helfer.lnk"

[Registry]
; Per-user COM registration (the equivalent of regasm /codebase, without needing admin).
Root: HKCU; Subkey: "Software\Classes\CLSID\{#AddinClsid}"; ValueType: string; \
  ValueData: "{#AddinProgId}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\CLSID\{#AddinClsid}\InprocServer32"; ValueType: string; \
  ValueData: "{sys}\mscoree.dll"
Root: HKCU; Subkey: "Software\Classes\CLSID\{#AddinClsid}\InprocServer32"; ValueType: string; \
  ValueName: "ThreadingModel"; ValueData: "Both"
Root: HKCU; Subkey: "Software\Classes\CLSID\{#AddinClsid}\InprocServer32"; ValueType: string; \
  ValueName: "Class"; ValueData: "{#AddinProgId}"
Root: HKCU; Subkey: "Software\Classes\CLSID\{#AddinClsid}\InprocServer32"; ValueType: string; \
  ValueName: "Assembly"; ValueData: "{#AddinAssembly}"
Root: HKCU; Subkey: "Software\Classes\CLSID\{#AddinClsid}\InprocServer32"; ValueType: string; \
  ValueName: "RuntimeVersion"; ValueData: "v4.0.30319"
Root: HKCU; Subkey: "Software\Classes\CLSID\{#AddinClsid}\InprocServer32"; ValueType: string; \
  ValueName: "CodeBase"; ValueData: "file:///{app}/WordScanAddin.dll"

Root: HKCU; Subkey: "Software\Classes\{#AddinProgId}"; ValueType: string; \
  ValueData: "{#AddinProgId}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Classes\{#AddinProgId}\CLSID"; ValueType: string; \
  ValueData: "{#AddinClsid}"

; Word's own add-in entry. LoadBehavior 3 = load at startup.
Root: HKCU; Subkey: "Software\Microsoft\Office\Word\Addins\{#AddinProgId}"; ValueType: dword; \
  ValueName: "LoadBehavior"; ValueData: "3"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\Microsoft\Office\Word\Addins\{#AddinProgId}"; ValueType: string; \
  ValueName: "FriendlyName"; ValueData: "Word Scan"
Root: HKCU; Subkey: "Software\Microsoft\Office\Word\Addins\{#AddinProgId}"; ValueType: string; \
  ValueName: "Description"; ValueData: "Scan documents directly into Word"

; Pre-0.3 versions registered an Office.js add-in through these; remove them on upgrade.
Root: HKCU; Subkey: "Software\Microsoft\Office\16.0\WEF\Developer"; \
  ValueName: "e667ed5b-c1c6-4f76-a374-a3a71521431d"; ValueType: none; Flags: deletevalue
Root: HKCU; Subkey: "Software\Microsoft\Office\16.0\WEF\TrustedCatalogs\e667ed5b-c1c6-4f76-a374-a3a71521431d"; \
  ValueType: none; Flags: deletekey

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
begin
  // Versions before 0.3 installed a background helper service and could auto-start it at
  // login. While it runs it locks its own exe, so stop it before [InstallDelete] tries.
  Exec('taskkill.exe', '/F /IM ScanHelper.exe', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

  // Word holds a lock on the add-in DLL while running, so installing over a live Word fails.
  if Exec('cmd.exe', '/C tasklist /FI "IMAGENAME eq WINWORD.EXE" | find /I "WINWORD.EXE"',
          '', SW_HIDE, ewWaitUntilTerminated, ResultCode) and (ResultCode = 0) then
  begin
    MsgBox(ExpandConstant('{cm:WordRunningWarning}'), mbError, MB_OK);
  end;
  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    MsgBox(ExpandConstant('{cm:RestartWordNotice}'), mbInformation, MB_OK);
  end;
end;
