# MAM + Tauri Workflow Template

Шаблон отдельного репозитория для подключения Tauri к `$mol/MAM` проекту через GitHub.

Что внутри:
- готовый `src-tauri` каркас
- скрипт сборки MAM-бандла
- reusable workflow (`workflow_call`)
- готовый publish workflow для релизов по тегу

## 1. Создать репозиторий из шаблона

1. Создайте новый репозиторий на GitHub (или `Use this template`).
2. Скопируйте содержимое этой папки в корень нового репозитория.
3. Убедитесь, что в репозитории есть ваш MAM модуль (например `mynamespace/application/app`).

## 2. Настроить путь к модулю

По умолчанию используется:
- модуль: `mynamespace/application/app`
- веб-бандл: `mynamespace/application/app/-`

Для своего проекта:
1. Задайте `MAM_MODULE_PATH` в `.github/workflows/tauri_publish.yml`.
2. Для local/dev задайте переменную окружения `MAM_MODULE_PATH` перед запуском npm-скриптов.
3. `devUrl` и `frontendDist` обновляются автоматически скриптом `scripts/configure-tauri-path.sh`.

## 3. Локальный запуск

```bash
npm ci
export MAM_MODULE_PATH=mynamespace/application/app
npm run mam:build
npm run tauri:dev
```

## 4. Локальная сборка

```bash
export MAM_MODULE_PATH=mynamespace/application/app
npm run tauri:build
```

Артефакты: `src-tauri/target/release/bundle/`

## 5. GitHub Actions

### Publish workflow

`.github/workflows/tauri_publish.yml`:
- `push` тега `v*` -> собирает Linux/macOS/Windows
- `workflow_dispatch` -> ручной запуск
- публикует GitHub Release и прикладывает инсталляторы

### Reusable workflow

`.github/workflows/tauri_reusable.yml` можно подключить из другого репозитория.

Пример подключения: `examples/use-reusable.yml`.

## 6. Релиз

```bash
git tag v0.1.0
git push origin v0.1.0
```

После этого workflow соберет и опубликует релиз.

## Prerequisites

- Node.js 24+
- Rust stable
- platform-specific Tauri prerequisites:
  - macOS: Xcode Command Line Tools
  - Windows: Visual Studio C++ Build Tools + WebView2
  - Linux: WebKitGTK и др. (установится в CI на Ubuntu)
