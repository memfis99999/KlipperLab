# 🛠️ KlipperLab — Modular Klipper Firmware Build & Simulation Environment

[GitHub — Yurii](https://github.com/memfis99999)

**KlipperLab** is a modular, container-based project designed to streamline Klipper firmware development, building, and simulation.
It consists of two isolated Docker environments:

- **EnvDocker** — for automated, reproducible firmware builds.
- **SimDocker** — for simulating and debugging Klipper-based printers.

All build tools and simulation dependencies are encapsulated. No host system pollution, easy CI integration, and maximum portability.

> **Note:**
> Your `klipper` repository (either your fork or the official upstream) **must be located in the *parent directory* alongside `KlipperLab`**, not inside it.

---

## 🚀 Project Structure

```tree
/your-workspace/
├── klipper/           # Klipper firmware source (your fork or upstream)
└── KlipperLab/        # This repository
    ├── EnvDocker_*    # Build container files
    ├── EnvDocker_res/ # Build environment configs/resources
    ├── SimDocker_*    # Simulation container files
    ├── SimDocker_res/ # Simulation configs/resources
    └── README.md      # Main KlipperLab README (this file)
```

---

## 📦 Components

### 1. EnvDocker — Firmware Build Environment

- Fully isolated build environment for Klipper firmware.
- Out-of-the-box support for batch building Creality K1 firmware (GD32, K1, K1 Max, etc.).
- Custom bash history and aliases imported for every session.
- Designed for CI pipelines and multi-printer workflows.
- Use with your own [klipper fork](https://github.com/memfis99999/klipper) for maximum compatibility (GD32 and Creality K1 support).

See [`EnvDocker_README.md`](./EnvDocker_README.md) for full usage instructions.

---

### 2. SimDocker — Printer Simulation & Debugging Environment

- Isolated environment for simulating Klipper firmware and printer workflows.
- Integrates [Fluidd](http://localhost/fluidd), [Moonraker](http://localhost:7125), and future [Mainsail] support.
- Suitable for development, debugging, and automated tests.
- Easily launches all simulation services and web UIs with one command.
- Custom bash history and aliases loaded per session.

See [`SimDocker_README.md`](./SimDocker_README.md) for detailed instructions.

---

## ⚠️ Status & Disclaimer

- **KlipperLab is NOT an official Klipper product.**
- Based on Klipper, but not affiliated with or endorsed by the original developers.
- "Klipper" may be a registered trademark; used here only for compatibility and identification.
- Project started: **2025**.

---

## 📝 License

This project is licensed under the **GNU General Public License v3.0 (GPLv3)**.
See [LICENSE](https://www.gnu.org/licenses/gpl-3.0.html) for details.

You are free to use, modify, distribute, and adapt this code
**provided you comply with the terms of the GPLv3.**

---

## 🔗 Further Documentation

- [EnvDocker_README.md](./EnvDocker_README.md) — Firmware build container guide
- [SimDocker_README.md](./SimDocker_README.md) — Simulation/debug container guide

---

**Happy hacking!**
— [Yurii](https://github.com/memfis99999)
