# 🛠️ Klipper Build Environment

[My Github](https://github.com/memfis99999)

Контейнер для сборки прошивок [Klipper](https://github.com/Klipper3d/klipper)

## ⚠️ This project is not an official Klipper product

It is based on Klipper and designed to simplify firmware building and simulation, but it is not affiliated with or supported by the original developers. "Klipper" may also be a registered trademark in other contexts; it is used here solely for compatibility and identification purposes

в изолированной и предсказуемой среде.
Предназначен для использования в CI, а также локально — без плясок с зависимостями на хосте.

## 💬

klipper — это путь до локального репозитория
scripts/EnvDocker_bash_hist.txt (опционально) — bash-история,
доступная сразу при запуске контейнера

---

## 🔧 Возможности

- Ubuntu 22.04 + весь необходимый тулчейн
- Поддержка UID/GID для синхронизации прав (--build-arg)
- Автоматическая подгрузка bash-истории
- Патченый внутри контейнера ci-install.sh без sudo
- Упрощённый bash-доступ с правами NOPASSWD:ALL

---

## 🧱 Сборка

./scripts/EnvDocker_build.sh

---

## 📦 Быстрый запуск

./scripts/EnvDocker_run.sh

---

## 📁 Структура

scripts/EnvDocker_bash_hist.txt   - история в bash контейнера для компиляции прошивки
scripts/EnvDocker_build.sh        - сборка контейнера для компиляции прошивки
scripts/EnvDocker_run.sh          - запуск контейнера для компиляции прошивки
scripts/EnvDocker_file            - Dockerfile контейнера для компиляции прошивки
scripts/EnvDocker_README.md       - этот файл

---

## 📝 Лицензия

Этот проект распространяется под лицензией **GNU General Public License v3.0 (GPLv3)**.
См. [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) для подробностей.

Ты вольен использовать, изменять, распространять и адаптировать этот код, при условии соблюдения условий лицензии GPLv3.
