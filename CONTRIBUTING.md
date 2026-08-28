# Contributing

Thanks for looking at this project. It has two independent pieces, so pick whichever one your
change touches.

## `helper/` — the scan service (.NET)

```
cd helper
dotnet run
```

`curl http://127.0.0.1:7643/health` should return `{"status":"ok"}`. The WIA COM call in
`WiaScanner.cs` needs a real scanner to test end-to-end; without one, `POST /scan` still exercises
the whole code path and fails with WIA's own "no device available" error, which is the expected
result on a machine with no scanner attached.

## `addin/` — the Word task pane (HTML/CSS/JS)

```
cd addin
npm install
npx office-addin-dev-certs install   # first time only, trusted local HTTPS cert
npm start                            # serves https://localhost:3000
npm run sideload                     # loads addin/manifest.xml into Word
npm run validate                     # lints manifest.xml against the Office schema
```

## Pull requests

- Keep `helper/` and `addin/` changes in separate PRs where practical — they build and release
  independently.
- Run `npm run validate` (manifest) and `dotnet build` (helper) before opening a PR; CI runs both
  on every push.
- This project follows [Semantic Versioning](https://semver.org/). Releases are cut by pushing a
  `vMAJOR.MINOR.PATCH` tag — see [`.github/workflows/release.yml`](.github/workflows/release.yml)
  for what that triggers. You don't need to bump version numbers yourself in a PR; that happens at
  release time.

## Reporting a bug

Open an issue with your Windows version, Word version/build, and — if it's scan-related — the
scanner make/model and whatever the helper printed to its console. That console output is the
fastest way to tell a WIA problem from an add-in problem.
