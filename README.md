# Add Tauri To Any $mol Project

Минимальные шаги.

## 1) Инициализируй Tauri в своем проекте

```bash
npm i -D @tauri-apps/cli
npx tauri init
npx tauri android init --ci
```

Убедись, что есть файл `src-tauri/icons/icon.png`.

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

Где `mam_module_path` это путь до entry-модуля $mol.

Примеры:

- `app`
- `bog/formigo/app`
- `mynamespace/application/app`

## 3) Запусти сборку и релиз

- Вручную: GitHub Actions -> `Tauri Desktop Build` -> Run workflow
- Или тегом:

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Что важно

- Android входит в обязательную сборку.
- Никаких скриптов копировать не нужно.
- Workflow сам ставит `mam` + `@tauri-apps/cli`.
- Workflow сам обновляет `devUrl` и `frontendDist` в `src-tauri/tauri.conf.json`.
- Если одна платформа упала, остальные артефакты всё равно публикуются в релиз.
- На `workflow_dispatch` создается draft release.
