# 📦 NetBSD Builder Ultimate (NBU) – Changelog

All notable improvements, fixes and changes since the initial version.

---

## [2.5] – 2026-10-19

### ✅ Added
- Interactive options to skip checksum verification and to enable a "fast download" mode (fewer retries), while preserving environment-variable overrides.
- Robust download retry mechanism and dynamic latest-STABLE resolution to improve reliability when fetching sources.

### 🐛 Fixed
- Reduced failed downloads by improving retry/backoff behavior and error handling.
- Adopted safer, non-destructive git options to avoid accidental repository corruption during source fetches.

### 🔄 Changed
- Updated script default STABLE version to `11.0`.
- Standardised interactive prompts to English.
- Improved CPU detection portability and applied minor cross-platform portability fixes.

### 📚 Documentation
- Expanded README with detailed execution instructions and clarifications for the interactive prompts.

---

## [2.4] – 2026-04-29

### ✅ Added
- BSD 2‑Clause license header with `All rights reserved`.
- Automatic copy of the generated ISO to `~/netbsd-build/dist/` (prevaccidental loss).
- Build timer displayed at the end.

### 🐛 Fixed
- Removed `pkgsrc` injection attempt via `xorriso` (it corrupted El Torito boot).  
  The ISO is now kept **original** and always bootable.
- Disk space check (minimum 20 GB) before starting.
- `run_privileged` function with fallback `sudo` / `su` for FreeBSD/NetBSD without sudo.

### 🔄 Changed
- Compiler question: `Use Clang? (y/N)` – default is GCC (stable, recommended).
- 32‑bit compatibility (`base32/comp32`) is now asked **only for `amd64`**.

---

## [2.3] – 2026-04-28 (internationalisation – planned)

### 🔜 Planned (not included in this release)
- Language selection (English / Spanish / Portuguese) – postponed for a future version.
- Full translation of all script messages.

> **Note**: The current script is English‑only. A multilingual version will come later.

---

## [2.2] – 2026-04-27

### ✅ Added
- Classic NetBSD daemon ASCII art at startup.
- Borders with box‑drawing characters (`╔ ╗ ╚ ╝ ║ ═`) and block elements (`▓ ▒ ░`).
- Colours (cyan, green, yellow, magenta).
- `Press ENTER to start` prompt before interactive configuration.

---

## [2.1] – 2026-04-27

### ✅ Added
- Multi‑platform dependency installation:
  - `apt` (Debian/Ubuntu)
  - `dnf`/`yum` (Fedora/RHEL/CentOS)
  - `pacman` (Arch Linux)
  - `pkg` (FreeBSD)
  - `pkgin` (NetBSD)
  - `brew` (macOS)
- `run_privileged` function that tries `sudo` and falls back to `su`.

---

## [2.0] – 2026-04-26

### 🔄 Changed
- **Completely removed** ISO post‑processing (xorriso). The ISO is now the original one built by `build.sh`.
- Copied the final ISO to `~/netbsd-build/dist/` as a simple backup.

---

## [1.4] – 2026-04-26 (broken attempt)

### ❌ Removed
- Attempt to inject `pkgsrc.tar.gz` and `postinstall.sh` using `xorriso`.  
  **Reason**: xorriso broke the El Torito boot image → ISO was unbootable.

---

## [1.3] – 2026-04-25

### ✅ Added
- Compiler choice: **GCC** (default) or **Clang** (experimental).
- Pass `USE_CLANG=yes`, `MKLLVM=yes`, `HAVE_LLVM=yes`, `MKGCC=no` when Clang selected.

> ⚠️ **Note**: Clang may fail on older `-current` versions (e.g., 11.99.5) due to an LLVM bug. GCC is strongly recommended for stable builds.

---

## [1.2] – 2026-04-25

### ✅ Added
- Support for 8 Tier‑I architectures:
  - `amd64`, `i386`, `evbarm`, `evbmips`, `evbppc`, `hpcarm`, `sparc64`, `xen`
- Interactive architecture selection.
- 32‑bit compatibility (`base32/comp32`) is now asked **only for `amd64`**.

---

## [1.1] – 2026-04-24

### ✅ Added
- **32‑bit compatibility** (`MKCOMPAT=yes`, `MKCOMPATX11=yes`).
- Interactive prompt: `Include 32‑bit application support? (y/N)`.
- Fixed installer error `Release set base32 does not exist`.

---

## [1.0] – 2026-04-20 (first release)

### ✅ Initial features
- Build NetBSD using the official `build.sh`.
- Choose version: `STABLE` (official tarballs) or `CURRENT` (git).
- Optional X11 build.
- Generate original ISO (no modifications).
- Simple timer.

---

## 🔮 Planned for future versions

- Full internationalisation (English / Spanish / Portuguese) – **in progress**.
- Safely embed `pkgsrc` into the ISO without breaking the boot (e.g., rebuild with `mkisofs`).
- Support for Tier‑II architectures.
- Automatic `pkgin` installation during system post‑install.

---

**Current stable version:** `2.5` – last changes on 2026-10-19.  
Generated ISO: `NetBSD-11.99.5-amd64-dvd.iso` (boots fine, login reached).  
Only harmless warning: postfix complains about empty hostname (no impact).
