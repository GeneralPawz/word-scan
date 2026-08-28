# Contributing

Thanks for looking at this project.

## Layout

- `com-addin/` — the add-in itself: a .NET Framework 4.8 COM add-in that Word loads in-process.
- `installer/` — the Inno Setup script that installs it and writes the per-user registry keys.
- `scripts/` — dependency-free icon generators (`make-icons.js`, `make-ico.js`).

## Building

```
dotnet build com-addin/WordScanAddin.csproj
```

Requires the .NET SDK plus the .NET Framework 4.8 targeting pack (installed with Visual Studio or
the standalone Developer Pack). The add-in references `Extensibility.dll` and `office.dll` from the
GAC — both ship with Office/Windows.

## Testing it in Word

Word loads the add-in from wherever the registry points, so you can register the build output
directly. Word must be closed for both registration and any rebuild (it locks the DLL).

The installer's `[Registry]` section documents the exact keys involved:

- `HKCU\Software\Classes\CLSID\{A1B2C3D4-...}\InprocServer32` — the managed COM registration
  (`mscoree.dll` shim, plus `Class`, `Assembly`, `RuntimeVersion`, `CodeBase`)
- `HKCU\Software\Classes\WordScanAddin.Connect` — the ProgID
- `HKCU\Software\Microsoft\Office\Word\Addins\WordScanAddin.Connect` — Word's own entry,
  `LoadBehavior` = 3

Point `CodeBase` at `com-addin\bin\Debug\net48\WordScanAddin.dll` and reopen Word.

> After a failed load, Word sets `LoadBehavior` to `2` so it won't retry. Set it back to `3`
> before each retest, or the add-in silently stays disabled.

The add-in writes a log to `%TEMP%\word-scan-addin.log` covering construction, `OnConnection`,
`GetCustomUI`, and any icon failure. That log is the fastest way to tell "Word never loaded it"
from "it loaded and then threw" — Word itself reports both as the same generic runtime error.

## Building the installer

Needs [Inno Setup 6](https://jrsoftware.org/isdl.php):

```
mkdir installer\input
copy com-addin\bin\Release\net48\WordScanAddin.dll installer\input\
ISCC installer\word-scan.iss /DMyAppVersion=0.3.0
```

CI compiles the installer on every push with a placeholder payload, so script errors surface
without needing a full build.

## Pull requests

- Run `dotnet build` before opening a PR; CI runs it plus the installer compile.
- This project follows [Semantic Versioning](https://semver.org/). Releases are cut by pushing a
  `vMAJOR.MINOR.PATCH` tag — see [`.github/workflows/release.yml`](.github/workflows/release.yml).
  You don't need to bump version numbers in a PR; that happens at release time.

## Reporting a bug

Open an issue with your Windows version, Word version/build, the scanner make/model, and the
contents of `%TEMP%\word-scan-addin.log`.
