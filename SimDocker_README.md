# 🛠️ KlipperLab — Firmware Simulation & Test Environment (SimDocker)

[GitHub — Yurii](https://github.com/memfis99999)

**KlipperLab SimDocker** provides an isolated, reproducible environment for simulating and testing [Klipper](https://github.com/Klipper3d/klipper) firmware and printer workflows.
All tools and dependencies are encapsulated in the container — no host pollution, no dependency headaches, maximum portability.
Suitable for development, debugging, automated testing, and CI scenarios.

---

## ⚠️ Project Status & Disclaimer

- **This is NOT an official Klipper product.**
- Based on Klipper, but not affiliated with or endorsed by the original developers.
- "Klipper" may be a registered trademark; it is used here only for compatibility and identification.
- Project started: **2025**.

---

## 💡 Overview

KlipperLab contains a container that fully encapsulates the printer simulation environment for firmware debugging and system integration.
The `klipper` repository (your fork or the official source) **must be located alongside** the `KlipperLab` directory, not inside it.

- To access the simulated printer, start the container.
- **Fluidd** is available at [http://localhost/fluidd](http://localhost/fluidd)
- **Moonraker** API/UI is available at [http://localhost:7125](http://localhost:7125)
- Bash command history and user aliases are loaded into the container on every launch for a smooth interactive experience (use ↑ and ↓ keys for previous commands).

---

## 🔧 Features

- Ubuntu 22.04 + all required toolchains, pre-installed and isolated
- Supports UID/GID mapping for correct file permissions (`--build-arg`)
- Automatic import of custom bash history and aliases
- Rootless Bash access with NOPASSWD:ALL for user convenience

---

## 🧱 Building the Docker Image

```sh
./SimDocker_build.sh
```

This script builds the container image with your current UID/GID for correct host–container file ownership.

---

## 📦 Running the Container

To launch the default simulation environment (starts all simulation services and web UI):

```sh
./SimDocker_run.sh
```

To run a custom command inside the simulation environment (for example, interactive config or manual firmware build):

```sh
./SimDocker_run.sh make menuconfig
```

To open an interactive shell inside the container (no auto-scripts):

```sh
./SimDocker_run.sh bash
```

---

## 📁 Directory Structure

```text
/your-workspace/
├── klipper/                      # Your local Klipper repo (see note below). Mounted as /klipper in the container.
└── KlipperLab/                   # This repository (SimDocker container for simulation environment)
    ├── SimDocker_build.sh*           # Build the simulation container
    ├── SimDocker_file                # Dockerfile for the simulation container
    ├── SimDocker_README.md           # This README
    ├── SimDocker_res/                # Resource directory (mounted as /config)
    │   ├── autostart.sh*                 # Runs at every container start
    │   ├── .bash_aliases                 # User aliases, loaded automatically
    │   ├── .config_simulavr              # .config file for Atmega644 firmware used in simulation
    │   ├── moonraker.conf                # Moonraker configuration
    │   ├── nginx.conf                    # Nginx configuration
    │   ├── log/                          # Created automatically. Logs location (not fully implemented yet)
    │   ├── out/                          # Created automatically. Firmware output for simulated printer (like Klipper's own 'out')
    │   ├── SimDocker_bash_hist.txt       # User bash history for the simulation container
    │   ├── simulavr.cfg                  # Printer configuration for the simulator
    │   ├── sites-enabled/                # Directory for nginx additional configs
    │   ├── start.sh*                     # Auto-run script: launches the full simulation stack (if container started without arguments)
    │   ├── test.sh*                      # For user script testing and debugging only (not for CI)
    │   └── TODO.txt                      # Project roadmap, in-progress features
    ├── SimDocker_run.sh*             # Starts the simulation container
    └── README.md                     # Main KlipperLab README (for the whole project, not just SimDocker)
```

**Note:**
The `klipper/` directory (your Klipper fork or source) must be present in the *parent directory* of KlipperLab, for example:

```text
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
