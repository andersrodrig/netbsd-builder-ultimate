![Static Badge](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge?logo=logo)
[![License](https://img.shields.io/github/license/andersrodrig/netbsd_builder_ultimate)](https://github.com/andersrodrig/netbsd_builder_ultimate/blob/main/LICENSE)

# ⚡ NetBSD Builder Ultimate

> **"Of course it runs NetBSD"** — Turn the complex NetBSD compilation process into a guided, automated, and efficient experience.

**NetBSD Builder Ultimate** is an advanced Bash wrapper for NetBSD's native `build.sh` system. It automates everything from host dependency installation to the final generation of a functional, original ISO image.

## ✨ Features

* **🌐 Multi-Platform:** Automated dependency installation for **macOS (Homebrew)**, **Linux** (Debian, Ubuntu, Fedora, RHEL, Arch), and **BSDs** (FreeBSD, OpenBSD, NetBSD).
* **🛠️ Interactive Configuration:** Easily choose versions, architectures, and components through a simple menu.
* **📦 Source Management:** Support for **STABLE (10.0)** official tarballs or **CURRENT** (bleeding-edge) via Git cloning.
* **🏗️ Custom Compilation:**
    * **X11** Support (Graphical Interface).
    * **32-bit** Compatibility (MKCOMPAT) for amd64 systems.
    * Choice between **GCC** and **Clang/LLVM** compilers.
* **🧹 Maintenance:** Built-in functions for cleaning previous builds and backing up source repositories.

---

## 🚀 Minimum Requirements

* **Disk Space:** At least **20GB** of free space.
* **Internet Connection:** Required to download toolchains and source code (several GBs).
* **Privileges:** `sudo` or `root` access required for dependency installation.

---

## 🛠️ How to Use

1.  **Grant execution permissions to the script:**
    ```bash
    chmod +x netbsd_builder_ultimate.sh
    ```

2.  **Start the process:**
    ```bash
    ./netbsd_builder_ultimate.sh
    ```

3.  **Follow the on-screen instructions:**
    * Select the version (**Stable** or **Current**).
    * Choose the target architecture (e.g., **amd64**, **evbarm**).
    * Choose X11 support and compatibility libraries.

---

## 📂 Directory Structure

The script organizes everything within `~/netbsd-build`:

| Folder | Description |
| :--- | :--- |
| `src/` | Main system source code. |
| `xsrc/` | X11 system source code. |
| `obj/` | Compiled binary objects (prevents full recompilation). |
| `destdir/` | Temporary "installation" directory before ISO creation. |
| `release/` | Final binary sets and distribution files. |
| `dist/` | **Storage for your final ISO and backups**. |

---

## 🏗️ Supported Architectures (Tier I)

The script simplifies the selection of primary architectures:
* `amd64` | `i386` | `evbarm` | `evbmips`
* `evbppc` | `hpcarm` | `sparc64` | `xen`

---

## ⚖️ License

This project is distributed under the **2-Clause BSD License**. See the script header for full copyright details and permissions.

**NetBSD®** is a registered trademark of The NetBSD Foundation, Inc.

