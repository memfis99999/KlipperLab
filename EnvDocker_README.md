
# 🛠️ KlipperLab — Firmware Build Environment (EnvDocker)

[GitHub — Yurii](https://github.com/memfis99999)

**KlipperLab EnvDocker** provides an isolated, fully reproducible environment for building [Klipper](https://github.com/Klipper3d/klipper) firmware.
All tools and dependencies are encapsulated in the container — no host pollution, no dependency headaches, maximum portability.
Suitable for CI pipelines or for easy local development and batch builds.

---

## ⚠️ Project Status & Disclaimer

- **This is NOT an official Klipper product.**
- Based on Klipper, but not affiliated with or endorsed by the original developers.
- "Klipper" may be a registered trademark; it is used here only for compatibility and identification.
- Project started: **2025**.

---

## 💡 Overview

KlipperLab automates firmware builds for your printers.
Ideal for batch-building firmware for multiple board variants and printers.

- **Supports out-of-the-box batch firmware compilation for 10+ Creality K1 control board variants.**
  - To use this feature, a fork of Klipper with GD32 and special firmware handling is required, e.g. [my fork](https://github.com/memfis99999/klipper).
  - Using other Klipper repositories disables automated K1 builds, but you can add scripts for other printers.
  - The `klipper` repository **must be located alongside** the `KlipperLab` directory, not inside it.
  - Bash command history and user aliases are loaded into the container on every launch for a smooth interactive experience (use ↑ and ↓ keys for previous commands).

---

## 🔧 Features

- Ubuntu 22.04 + all required toolchains, pre-installed and isolated
- Supports UID/GID mapping for correct file permissions (`--build-arg`)
- Automatic import of custom bash history and aliases
- Patched in-container `ci-install.sh` (runs without sudo)
- Rootless Bash access with NOPASSWD:ALL for user convenience

---

## 🧱 Building the Docker Image

```sh
./EnvDocker_build.sh
```

This script builds the container image with your current UID/GID for correct host–container file ownership.

---

## 📦 Running the Container

Run the default build script (compiles all Creality K1 firmware, if present):

```sh
./EnvDocker_run.sh
```

Run a custom command inside the build environment (e.g., `make menuconfig`):

```sh
./EnvDocker_run.sh make menuconfig
```

Drop into an interactive shell in the container (no auto-scripts):

```sh
./EnvDocker_run.sh bash
```

---

## 📁 Directory Structure

```tree
./
├── klipper/                  # Your local Klipper repo (see note below). Mounted as /klipper in the container.
└── KlipperLab/               # This repository (EnvDocker build environment)
    ├── EnvDocker_build.sh*       # Build the firmware container
    ├── EnvDocker_file            # Dockerfile for the build container
    ├── EnvDocker_README.md       # This README
    ├── EnvDocker_res/            # Resource directory (mounted as /config)
    │   ├── autostart.sh*             # Runs at every container start
    │   ├── .bash_aliases             # User aliases, loaded automatically
    │   ├── configs/                  # Defconfig sets for batch firmware builds (add your own)
    │   │   └── Creality_K1/              # Example configs for Creality K1 boards
    │   ├── creality_K1.sh*           # Automated batch build script for Creality K1 (manual or auto in start.sh)
    │   ├── EnvDocker_bash_hist.txt   # User bash history for the build container
    │   ├── FIRMWARE/                 # Created automatically. Stores compiled firmware
    │   │   └── Creality_K1/              # Firmware output, description, and dictionary files for debugging
    │   ├── logs/                     # Created automatically. Find logs here
    │   ├── out/                      # Created automatically. Last compilation output (like Klipper's own 'out')
    │   ├── start.sh*                 # Auto-run script (if container started without arguments)
    │   ├── test.sh*                  # For user script testing and debugging only (not for CI)
    │   └── TODO.txt                  # Project roadmap, in-progress features
    ├── EnvDocker_run.sh*         # Run the build container
    └── README.md                 # Main KlipperLab README (for the whole project, not just EnvDocker)
```

**Note:**
The `klipper/` directory (your Klipper fork or source) must be present in the *parent directory* of KlipperLab, e.g.:

```tree
/your-workspace/
├── klipper/
└── KlipperLab/
```

---

## 📝 License

This project is licensed under the **GNU General Public License v3.0 (GPLv3)**.
See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) for details.

You are free to use, modify, distribute, and adapt this code
**provided you comply with the terms of the GPLv3.**

---
