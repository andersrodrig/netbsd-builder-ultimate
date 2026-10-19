# ⚡ NetBSD Builder Ultimate

> **"Of course it runs NetBSD"** — Turn the complex NetBSD compilation process into a guided, automated, and efficient experience.

**NetBSD Builder Ultimate** is an advanced Bash wrapper for NetBSD's native `build.sh` system. It automates everything from host dependency installation to the final generation of a functional, original ISO image.

## ✨ Features

* **🌐 Multi-Platform:** Automated dependency installation for **macOS (Homebrew)**, **Linux** (Debian, Ubuntu, Fedora, RHEL, Arch), and **BSDs** (FreeBSD, OpenBSD, NetBSD).
* **🛠️ Interactive Configuration:** Easily choose versions, architectures, and components through a simple menu.
* **📦 Source Management:** Support for **STABLE (11.x)** official tarballs or **CURRENT** (bleeding-edge) via Git cloning.
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
* **Terminal Access:** You must run it from a terminal shell on your host OS.

---

## 📍 Where to Run It

This script is meant to be executed from a terminal on a real host machine running:

* **Linux** (Debian/Ubuntu, Fedora/RHEL, Arch, etc.)
* **macOS**
* **BSD** (FreeBSD, OpenBSD, NetBSD)

It is not a GUI application and does not run inside a browser. Use a normal shell such as:

* `bash`
* `zsh`
* `sh`
* Terminal.app on macOS
* GNOME Terminal, Konsole, iTerm2, or your system terminal emulator
* WSL2 + Linux shell if you are using Windows

### Local execution from a cloned repository

```bash
git clone https://github.com/andersrodrig/netbsd-builder-ultimate.git
cd netbsd-builder-ultimate
chmod +x netbsd_builder_ultimate.sh
./netbsd_builder_ultimate.sh
```

### Run it from any directory

```bash
bash /path/to/netbsd_builder_ultimate.sh
```

Example:

```bash
bash ~/Downloads/netbsd_builder_ultimate.sh
```

### Important execution notes

* Run it from a normal shell session with access to `sudo` or as `root`.
* The script creates its working tree under `~/netbsd-build`.
* It downloads source code and builds in the current host environment.
* The build process can take several hours and consumes a large amount of disk space.

---

## 🛠️ How to Use

1. **Grant execution permissions to the script:**
    ```bash
    chmod +x netbsd_builder_ultimate.sh
    ```

2. **Start the process from the repository directory:**
    ```bash
    ./netbsd_builder_ultimate.sh
    ```

3. **Or run it directly via bash from any location:**
    ```bash
    bash /path/to/netbsd_builder_ultimate.sh
    ```

4. **Follow the on-screen instructions:**
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

