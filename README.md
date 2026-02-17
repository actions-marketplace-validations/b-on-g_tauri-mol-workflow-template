# Add Tauri To Any $mol Project

Минимальные шаги.

## 1) скопируй `src-tauri`

скопируй папку `src-tauri` из этого репозитория в корень своего $mol-проекта.

## 2) Добавь workflow в свой проект

Создай `.github/workflows/tauri.yml`:

```yml
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

Где `mam_module_path` это путь до твоего entry-модуля.

Примеры:

- `bog/formigo/app`
- `mynamespace/application/app`

## 3) Запусти сборку

- Вручную: GitHub Actions -> `Tauri Desktop Build` -> Run workflow
- Или тегом:

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Что важно

- Никаких скриптов копировать не нужно.
- Workflow сам ставит `mam` + `@tauri-apps/cli`.
- Workflow сам обновляет `devUrl` и `frontendDist` в `src-tauri/tauri.conf.json`.
