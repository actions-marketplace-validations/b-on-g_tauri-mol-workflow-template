# Tauri + $mol Build

Build cross-platform Tauri apps from $mol/MAM modules. Two ways to use:

- **Action** — single step, you control the matrix (publishable on Marketplace)
- **Reusable Workflow** — all platforms out of the box

---

## Action (recommended for new projects)

### Minimal — one platform

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: b-on-g/tauri-mol-workflow-template@master
    with:
      module: "appname/app"
```

### All platforms via matrix

```yaml
name: Tauri Build

on:
  workflow_dispatch:
  push:
    tags:
      - 'v*'

jobs:
  build:
    strategy:
      fail-fast: false
      matrix:
        include:
          - os: macos-latest
            platform: desktop
          - os: windows-latest
            platform: desktop
          - os: ubuntu-latest
            platform: desktop
          - os: ubuntu-latest
            platform: android
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: b-on-g/tauri-mol-workflow-template@master
        with:
          module: "appname/app"
          platform: ${{ matrix.platform }}

  release:
    needs: build
    if: always()
    runs-on: ubuntu-latest
    steps:
      - uses: actions/download-artifact@v4
        with:
          pattern: tauri-*
          merge-multiple: true
      - uses: softprops/action-gh-release@v2
        with:
          draft: ${{ github.event_name == 'workflow_dispatch' }}
          files: |
            **/*.dmg
            **/*.msi
            **/*.exe
            **/*.deb
            **/*.AppImage
            **/*.apk
            **/*.aab
            **/*.ipa
```

### Action inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `module` | yes | — | MAM module path (e.g. `appname/app`) |
| `platform` | no | `desktop` | `desktop`, `android`, or `ios` |
| `dev-port` | no | `9080` | MAM dev server port |
| `tauri-config` | no | `src-tauri/tauri.conf.json` | Path to tauri config |
| `ios-export-method` | no | `app-store-connect` | iOS export method |
| `timeout` | no | `240` | MAM build timeout (seconds) |

---

## Reusable Workflow (legacy, still works)

### Setup

1. Init Tauri in your project:

```bash
npm i -D @tauri-apps/cli
npx tauri init
npx tauri android init --ci
```

Make sure `src-tauri/icons/icon.png` exists.

2. Create `.github/workflows/tauri.yml`:

```yaml
name: Tauri Desktop Build

on:
  workflow_dispatch:
  push:
    tags:
      - 'v*'

jobs:
  tauri:
    uses: b-on-g/tauri-mol-workflow-template/.github/workflows/tauri_reusable.yml@master
    with:
      mam_module_path: app
      mam_dev_port: '9080'
      tauri_config: src-tauri/tauri.conf.json
    secrets: inherit
```

`mam_module_path` — path to your $mol entry module. Examples:
- `app`
- `bog/formigo/app`
- `mynamespace/application/app`

3. Run:

```bash
git tag v0.1.0
git push origin v0.1.0
```

Or manually: GitHub Actions -> Run workflow.

---

## How it works

- Builds MAM web bundle (`npx mam MODULE`), waits for output
- Auto-generates Tauri icons from `src-tauri/icons/icon.png` or `.svg`
- Updates `tauri.conf.json` with correct `devUrl` and `frontendDist` paths
- Builds Tauri for the target platform
- Uploads artifacts (`.dmg`, `.msi`, `.deb`, `.AppImage`, `.apk`, `.aab`, `.ipa`)
- If one platform fails, others still publish to release

## Requirements

- Node.js 24+
- `src-tauri/icons/icon.png` for icon generation
- No scripts to copy — everything is handled by the action/workflow
