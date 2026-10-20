#!/bin/bash
# =============================================================================
# NetBSD Builder Ultimate
#
# Copyright (C) 2025-2026 Anderson Rodrigues <andersrodrig@hotmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
# =============================================================================

set -euo pipefail

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

log() { echo -e "\n${GREEN}>>> [INFO] $1${NC}"; }
error() { echo -e "\n${RED}[ERROR] $1${NC}" >&2; exit 1; }
warn() { echo -e "\n${YELLOW}[WARNING] $1${NC}"; }

# -----------------------------------------------------------------------------
# WELCOME HEADER (original ASCII art)
# -----------------------------------------------------------------------------
show_welcome() {
    clear
    echo -e "${CYAN}"
    cat << "EOF"
                                              __,gnnnOCCCCCOObaau,_
                 _._                    __,gnnCCCCCCCCOPF"''        ~
                (N\XCbngg,._____. ,gnnndCCCCCCCCCCCCF"___,,,,___
                 \N\XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCOOOOPYvv.
                  \N\XCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCPF"''
                   \N\XCCCCCCCCCCCCCCCCCCCCCCCCCOF"'
                    \N\XCCCCCCCCCCCCCCCCCCCCOF"'
                     \N\XCCCCCCCCCCCCCCCPF"'
                      \N\"PCOCCCOCCFP""
                       \N\
                        \N\                                               ---
   qnnnn.     qnnnnr     \N\       qgggaagge,     ,spsqs,  qgggaaagga,.  | R |
     NNNNL     "NN                  BBB   "BBb   ;SS   "Ss  DDD    "VDDm  ---
     NNVNNb,    NN           ,t     BBB    IBP   SSk,    "  DDD      "DDb
     NN "VNNp,  NN  .epqe, zttttz   BBBgggdBP'   "SSSSp,    DDD       YDD
     NN   "VNNp,NN eEY__YA   TT     BBB""""GBm,    "SSSSR   DDD       ADD
     NN     "VNbNN EEF""""'  TT     BBB     BBB       "YSL  DDD      .DDP
     NN       "YNN VEL    ,  TT     BBB    _BBP s,     ISF  DDD     ,DDD'
   adNNbe      "NN "VEggdF   ttgt  dBBBaaadBBF'  YSgggdSP' dDDDaaadCDF"
                                                        
                                \NN\
                                 \NN\
                                  \NNA.
                                   \NNA,
                                    \NNN,
                                     \NNN\
                                      \NNN\
                                       \NNNA
EOF
    echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${YELLOW}║                         ${GREEN}NetBSD Builder Ultimate     ${YELLOW}                         ║${NC}"
    echo -e "${YELLOW}║                                                                              ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${YELLOW}           ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}▓▓▒░${BLUE}           NetBSD  ${GREEN}\"Of course it runs NetBSD\"${BLUE}           ${CYAN}░▒▓▓${YELLOW}           ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${YELLOW}           ║${NC}"
    echo -e "${YELLOW}║                                                                              ║${NC}"
    echo -e "${YELLOW}║   ${MAGENTA}Welcome to the personalized NetBSD ISO builder!${YELLOW}                            ║${NC}"
    echo -e "${YELLOW}║   This script will guide you through the options and start the build.        ║${NC}"
    echo -e "${YELLOW}║   The process can take several hours. Please be patient.                     ║${NC}"
    echo -e "${YELLOW}║                                                                              ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}Note: The generated ISO is original (no extra modifications).${YELLOW}              ║${NC}"
    echo -e "${YELLOW}║   To add pkgsrc, do it manually after installation.                          ║${NC}"
    echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    read -r -p "$(printf '%b▶ Press ENTER to start the build...%b' "$CYAN" "$NC")" _dummy
    echo ""
}

# -----------------------------------------------------------------------------
# INITIAL SETTINGS
# -----------------------------------------------------------------------------
BASE_DIR="$HOME/netbsd-build"
SRC_DIR="$BASE_DIR/src"
XSRC_DIR="$BASE_DIR/xsrc"
DIST_DIR="$BASE_DIR/dist"
OBJ_DIR="$BASE_DIR/obj"
DEST_DIR="$BASE_DIR/destdir"
REL_DIR="$BASE_DIR/release"
# STABLE_VERSION vazio = detectar/listar; preenchido = respeitar
STABLE_VERSION="${STABLE_VERSION:-}"
CURRENT_BRANCH="${CURRENT_BRANCH:-trunk}"
BUILD_JOBS=1

DOWNLOAD_TRIES=${DOWNLOAD_TRIES:-6}
DOWNLOAD_WAIT=${DOWNLOAD_WAIT:-5}

if command -v nproc >/dev/null 2>&1; then
    BUILD_JOBS=$(nproc)
elif command -v sysctl >/dev/null 2>&1; then
    BUILD_JOBS=$(sysctl -n hw.ncpu 2>/dev/null || echo 1)
fi
# Validação numérica para evitar -j vazio ou não-numérico
case "$BUILD_JOBS" in
    ''|*[!0-9]*) BUILD_JOBS=1 ;;
esac

mkdir -p "$BASE_DIR" "$DIST_DIR" "$OBJ_DIR" "$DEST_DIR" "$REL_DIR"
START_TIME=$(date +%s)

# -----------------------------------------------------------------------------
# UTILS
# -----------------------------------------------------------------------------
download_with_retry() {
    local url="$1"
    local out="$2"
    local tries=${3:-$DOWNLOAD_TRIES}
    local wait=${4:-$DOWNLOAD_WAIT}

    local attempt=1
    local backoff=$wait

    while [ "$attempt" -le "$tries" ]; do
        if command -v wget >/dev/null 2>&1; then
            log "Downloading $url -> $out (wget, attempt $attempt/$tries)"
            if wget --tries=1 --waitretry=0 --timeout=30 "$url" -O "$out.part"; then
                mv -f "$out.part" "$out"
                return 0
            else
                warn "wget attempt $attempt failed for $url"
                rm -f "$out.part" 2>/dev/null || true
            fi
        fi

        if command -v curl >/dev/null 2>&1; then
            log "Downloading $url -> $out (curl, attempt $attempt/$tries)"
            if curl --fail --location --max-time 600 --retry 0 "$url" -o "$out.part"; then
                mv -f "$out.part" "$out"
                return 0
            else
                warn "curl attempt $attempt failed for $url"
                rm -f "$out.part" 2>/dev/null || true
            fi
        fi

        if [ "$attempt" -lt "$tries" ]; then
            log "Retrying in ${backoff}s..."
            sleep "$backoff"
            backoff=$((backoff * 2))
        fi
        attempt=$((attempt + 1))
    done

    return 1
}

# Lista versões stable do CDN (uma por linha, ordenadas com sort -V)
list_stable_versions() {
    local index_url="https://cdn.netbsd.org/pub/NetBSD/"
    local html
    if ! html=$(curl -fsS "$index_url" 2>/dev/null); then
        warn "Could not fetch $index_url" >&2
        return 1
    fi

    local versions
    versions=$(printf "%s" "$html" \
        | grep -oE 'NetBSD-[0-9]+\.[0-9]+' \
        | sed 's/^NetBSD-//' \
        | sort -u -V)

    if [ -z "$versions" ]; then
        warn "No NetBSD versions found on CDN index" >&2
        return 1
    fi

    printf "%s\n" "$versions"
}

# Preenche STABLE_VERSION (respeita env; senão lista e pergunta)
choose_stable_version() {
    if [ -n "${STABLE_VERSION:-}" ]; then
        log "Using STABLE_VERSION=$STABLE_VERSION (from environment)"
        return 0
    fi

    local versions
    if ! versions=$(list_stable_versions); then
        warn "Could not list versions from CDN — falling back to default 11.0"
        STABLE_VERSION="11.0"
        return 0
    fi

    local -a arr=()
    while IFS= read -r v; do
        [ -n "$v" ] && arr+=("$v")
    done <<< "$versions"

    echo ""
    echo "Available stable versions (from cdn.netbsd.org):"
    local i=1
    for v in "${arr[@]}"; do
        echo " $i) $v"
        i=$((i+1))
    done

    local default_idx=${#arr[@]}
    local pick
    while true; do
        read -r -p "Choice (1-${#arr[@]}) [${default_idx}]: " pick
        pick="${pick:-$default_idx}"
        if [[ "$pick" =~ ^[0-9]+$ ]] && [ "$pick" -ge 1 ] && [ "$pick" -le "${#arr[@]}" ]; then
            STABLE_VERSION="${arr[$((pick-1))]}"
            break
        fi
        warn "Invalid choice. Enter 1-${#arr[@]}."
    done

    log "Selected STABLE_VERSION=$STABLE_VERSION"
}

# -----------------------------------------------------------------------------
# VERIFICATION OPTIONS
# -----------------------------------------------------------------------------
ask_verification_options() {
    if [ -z "${SKIP_CHECKSUMS+x}" ]; then
        read -r -p "Verify checksums of downloaded tarballs? (Y/n) " verify_resp
        verify_resp="${verify_resp:-Y}"
        if [[ "$verify_resp" =~ ^[Nn]$ ]]; then
            SKIP_CHECKSUMS=1
        else
            SKIP_CHECKSUMS=0
        fi
    else
        log "SKIP_CHECKSUMS set in environment: ${SKIP_CHECKSUMS}"
    fi

    if [ -z "${DOWNLOAD_TRIES+x}" ] && [ -z "${DOWNLOAD_WAIT+x}" ]; then
        read -r -p "Use fast download mode (fewer retries)? (y/N) " fast_resp
        fast_resp="${fast_resp:-N}"
        if [[ "$fast_resp" =~ ^(y|yes)$ ]]; then
            DOWNLOAD_TRIES=2
            DOWNLOAD_WAIT=2
        else
            DOWNLOAD_TRIES=${DOWNLOAD_TRIES:-6}
            DOWNLOAD_WAIT=${DOWNLOAD_WAIT:-5}
        fi
    else
        log "DOWNLOAD_TRIES/WAIT set in environment: tries=$DOWNLOAD_TRIES wait=$DOWNLOAD_WAIT"
    fi

    log "Checksum verification: $( [ "$SKIP_CHECKSUMS" -eq 1 ] && echo 'disabled' || echo 'enabled')"
    log "Download retries: $DOWNLOAD_TRIES, initial wait ${DOWNLOAD_WAIT}s"
}

verify_tarballs_checksums() {
    local base_url="$1"; shift
    local files=("$@")

    if [ "${SKIP_CHECKSUMS:-0}" = "1" ]; then
        log "Skipping checksum verification (SKIP_CHECKSUMS=1)"
        return 0
    fi

    local checksum_candidates=("SHA512" "SHA256" "sha512" "sha256")
    local checksum_file_local=""
    local checksum_algo=""

    for cand in "${checksum_candidates[@]}"; do
        local remote="${base_url}/${cand}"
        local localpath="$BASE_DIR/${cand}"
        if download_with_retry "$remote" "$localpath" 3 2; then
            checksum_file_local="$localpath"
            if echo "$cand" | grep -qi "512"; then
                checksum_algo=512
            else
                checksum_algo=256
            fi
            log "Using checksum file: $remote (algo: sha${checksum_algo})"
            break
        fi
    done

    if [ -z "$checksum_file_local" ]; then
        warn "No checksum file found on CDN — skipping checksum verification"
        return 0
    fi

    local sumcmd=""
    if [ "$checksum_algo" -eq 512 ]; then
        if command -v sha512sum >/dev/null 2>&1; then
            sumcmd="sha512sum"
        elif command -v shasum >/dev/null 2>&1; then
            sumcmd="shasum -a 512"
        fi
    else
        if command -v sha256sum >/dev/null 2>&1; then
            sumcmd="sha256sum"
        elif command -v shasum >/dev/null 2>&1; then
            sumcmd="shasum -a 256"
        fi
    fi

    if [ -z "$sumcmd" ]; then
        warn "No checksum tool found — cannot verify checksums"
        return 0
    fi

    local failures=0
    for f in "${files[@]}"; do
        local path="$BASE_DIR/$f"
        if [ ! -f "$path" ]; then
            warn "File not found: $path"
            failures=$((failures + 1))
            continue
        fi

        local expected=""
        expected=$(grep -E "[0-9a-fA-F]{64,128}\s+${f}$" "$checksum_file_local" | awk '{print $1}' | head -n1 || true)
        if [ -z "$expected" ]; then
            expected=$(grep -E "[0-9a-fA-F]{64,128}\s+\./${f}$" "$checksum_file_local" | awk '{print $1}' | head -n1 || true)
        fi
        if [ -z "$expected" ]; then
            expected=$(grep -i "${f}" "$checksum_file_local" | grep -oE "[0-9a-fA-F]{64,128}" | head -n1 || true)
        fi

        if [ -z "$expected" ]; then
            warn "Could not find expected checksum for $f — skipping this file"
            continue
        fi

        local local_sum
        local_sum=$( $sumcmd "$path" | awk '{print $1}' ) || true

        if [ -n "$local_sum" ] && [ "${local_sum,,}" = "${expected,,}" ]; then
            log "Checksum OK: $f"
        else
            warn "Checksum mismatch for $f (expected: ${expected}, got: ${local_sum:-none})"
            failures=$((failures + 1))
        fi
    done

    if [ "$failures" -gt 0 ]; then
        return 1
    fi
    return 0
}

# -----------------------------------------------------------------------------
# INTERACTIVE CONFIGURATION
# -----------------------------------------------------------------------------
select_version() {
    echo ""
    echo "============================================================"
    echo " Select NetBSD version:"
    echo " 1) STABLE (official tarballs, fast)"
    echo " 2) CURRENT (git, unstable)"
    echo "============================================================"
    while true; do
        read -r -p "Choice (1 or 2) [1]: " ver_choice
        ver_choice="${ver_choice:-1}"
        case "$ver_choice" in
            1) VERSION_TYPE="stable"; break ;;
            2) VERSION_TYPE="current"; break ;;
            *) warn "Invalid option." ;;
        esac
    done

    if [ "$VERSION_TYPE" = "stable" ]; then
        choose_stable_version
        log "Using STABLE_VERSION=$STABLE_VERSION"
    fi

    log "Version: $VERSION_TYPE"
}

select_architecture() {
    echo ""
    echo "Available architectures:"
    echo " 1) amd64    2) i386     3) evbarm   4) evbmips"
    echo " 5) evbppc   6) hpcarm   7) sparc64  8) xen"
    while true; do
        read -r -p "Choice (1-8) [1]: " choice
        choice="${choice:-1}"
        case "$choice" in
            1) TARGET_MACHINE="amd64"; break ;;
            2) TARGET_MACHINE="i386"; break ;;
            3) TARGET_MACHINE="evbarm"; break ;;
            4) TARGET_MACHINE="evbmips"; break ;;
            5) TARGET_MACHINE="evbppc"; break ;;
            6) TARGET_MACHINE="hpcarm"; break ;;
            7) TARGET_MACHINE="sparc64"; break ;;
            8) TARGET_MACHINE="xen"; break ;;
            *) warn "Invalid. Enter 1-8." ;;
        esac
    done
    log "Architecture: $TARGET_MACHINE"
}

ask_x11() {
    while true; do
        read -r -p "Build X11 (graphical interface)? (y/N) " resp
        resp="${resp,,}"
        if [[ "$resp" =~ ^(y|yes)$ ]]; then
            BUILD_X11=true
            break
        elif [[ -z "$resp" || "$resp" =~ ^(n|no)$ ]]; then
            BUILD_X11=false
            break
        else
            warn "Answer y or n."
        fi
    done
}

ask_32bit_compat() {
    while true; do
        echo ""
        read -r -p "Include 32-bit application support (base32/comp32)? (y/N) " resp
        resp="${resp,,}"
        if [[ "$resp" =~ ^(y|yes)$ ]]; then
            ENABLE_32BIT=true
            log "32-bit compatibility will be included (MKCOMPAT=yes)"
            break
        elif [[ -z "$resp" || "$resp" =~ ^(n|no)$ ]]; then
            ENABLE_32BIT=false
            log "32-bit compatibility will NOT be included"
            break
        else
            warn "Answer y or n."
        fi
    done
}

ask_compiler() {
    while true; do
        echo ""
        read -r -p "Use Clang as default compiler instead of GCC? (y/N) " resp
        resp="${resp,,}"
        if [[ "$resp" =~ ^(y|yes)$ ]]; then
            USE_CLANG=true
            log "Compilation with Clang/LLVM"
            break
        elif [[ -z "$resp" || "$resp" =~ ^(n|no)$ ]]; then
            USE_CLANG=false
            log "Compilation with GCC (default)"
            break
        else
            warn "Answer y or n."
        fi
    done
}

# -----------------------------------------------------------------------------
# CHECKS AND DEPENDENCIES
# -----------------------------------------------------------------------------
check_disk_space() {
    log "Checking disk space (minimum 20GB)..."
    local avail
    if df --output=avail "$BASE_DIR" >/dev/null 2>&1; then
        avail=$(df --output=avail "$BASE_DIR" | tail -1 | awk '{print int($1/1024/1024)}')
    else
        avail=$(df -k "$BASE_DIR" | tail -1 | awk '{print int($4/1024/1024)}')
    fi
    if [ "$avail" -lt 20 ]; then
        error "Only ${avail}GB free (minimum 20GB)."
    fi
    log "Disk space OK: ${avail}GB available."
}

run_privileged() {
    local cmd="$1"
    if command -v sudo >/dev/null 2>&1; then
        # sudo normal: pede SUA senha se necessário (não a do root)
        sudo sh -c "$cmd"
    elif [ "$(id -u)" -eq 0 ]; then
        sh -c "$cmd"
    elif command -v su >/dev/null 2>&1; then
        su -c "$cmd"
    else
        error "Unable to execute '$cmd' as root. Install sudo or run manually."
    fi
}

install_dependencies() {
    log "Detecting operating system and package manager..."

    if [[ "$(uname -s)" == "Darwin" ]]; then
        log "macOS detected. Installing dependencies via Homebrew..."
        if ! command -v brew >/dev/null 2>&1; then
            echo -e "${YELLOW}Homebrew not found. Installing...${NC}"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || error "Failed to install Homebrew"
        fi
        brew update
        brew install gcc bison flex openssl libelf bc gawk wget tar xz bzip2 xorriso grub mtools cpio pkg-config python3 texinfo rsync unzip patch zlib cmake git curl
        log "Dependencies installed via Homebrew."
        return
    fi

    if command -v apt-get >/dev/null 2>&1; then
        log "apt package manager detected (Debian/Ubuntu)"
        log "You may be prompted for your sudo password to install build deps."
        run_privileged "apt-get update && apt-get install -y build-essential bison flex libssl-dev libelf-dev bc gawk wget tar xz-utils bzip2 xorriso grub-pc-bin grub-efi-amd64-bin mtools cpio pkg-config python3 texinfo rsync unzip patch zlib1g-dev cmake git curl"

    elif command -v dnf >/dev/null 2>&1; then
        log "dnf package manager detected (Fedora/RHEL)"
        run_privileged "dnf groupinstall -y 'Development Tools' && dnf install -y bison flex openssl-devel elfutils-libelf-devel bc gawk wget tar xz bzip2 xorriso grub2-tools grub2-pc mtools cpio pkgconf python3 texinfo rsync unzip patch zlib-devel cmake git curl"

    elif command -v yum >/dev/null 2>&1; then
        log "yum package manager detected (CentOS/RHEL 7)"
        run_privileged "yum groupinstall -y 'Development Tools' && yum install -y bison flex openssl-devel elfutils-libelf-devel bc gawk wget tar xz bzip2 xorriso grub2-tools mtools cpio pkgconf python3 texinfo rsync unzip patch zlib-devel cmake git curl"

    elif command -v pacman >/dev/null 2>&1; then
        log "pacman package manager detected (Arch Linux)"
        run_privileged "pacman -S --needed --noconfirm base-devel bison flex openssl libelf bc gawk wget tar xz bzip2 libisoburn grub mtools cpio pkg-config python texinfo rsync unzip patch zlib cmake git curl"

    elif command -v pkg >/dev/null 2>&1; then
        log "pkg package manager detected (FreeBSD)"
        run_privileged "pkg update && pkg install -y gcc bison flex openssl elfutils bc gawk wget tar xz bzip2 xorriso grub2-tools mtools cpio pkgconf python3 texinfo rsync unzip patch zlib cmake git curl"

    elif command -v pkg_add >/dev/null 2>&1; then
        log "pkg_add detected (NetBSD). Ensuring pkgin is available..."
        if ! command -v pkgin >/dev/null 2>&1; then
            run_privileged "pkg_add pkgin" || error "Failed to install pkgin"
        fi
        run_privileged "pkgin update && pkgin install -y gcc bison flex openssl elfutils bc gawk wget tar xz bzip2 xorriso grub2 mtools cpio pkg-config python37 texinfo rsync unzip patch zlib cmake git curl"

    else
        warn "No known package manager found. Install dependencies manually."
    fi

    log "Host dependencies checked/installed."
}

clean_previous_builds() {
    read -r -p "Remove previous destdir and release directories? (y/N) " resp
    if [[ "$resp" =~ ^[Yy]$ ]]; then
        rm -rf "$DEST_DIR" "$REL_DIR"
        mkdir -p "$DEST_DIR" "$REL_DIR"
        log "Light cleanup done."
    fi
}

# -----------------------------------------------------------------------------
# SOURCE CODE RETRIEVAL
# -----------------------------------------------------------------------------
fetch_stable_tarballs() {
    log "Downloading stable tarballs (NetBSD ${STABLE_VERSION})..."
    cd "$BASE_DIR"
    local base_url="https://cdn.netbsd.org/pub/NetBSD/NetBSD-${STABLE_VERSION}/source/sets"
    local tarballs=("syssrc.tgz" "gnusrc.tgz" "sharesrc.tgz" "libsrc.tgz" "external.tgz")
    [ "$BUILD_X11" = true ] && tarballs+=("xsrc.tgz")
    for tgz in "${tarballs[@]}"; do
        if [ ! -f "$BASE_DIR/$tgz" ]; then
            if ! download_with_retry "${base_url}/${tgz}" "$BASE_DIR/$tgz"; then
                error "Failed to download $tgz after retries"
            fi
        fi
    done

    if [ "${SKIP_CHECKSUMS:-0}" != "1" ]; then
        if ! verify_tarballs_checksums "$base_url" "${tarballs[@]}"; then
            error "Checksum verification failed. Aborting."
        fi
    else
        log "Checksum verification skipped per user choice."
    fi

    mkdir -p "$SRC_DIR"
    for tgz in "${tarballs[@]}"; do
        tar -xzf "$BASE_DIR/$tgz" -C "$SRC_DIR" --skip-old-files
    done
    if [ "$BUILD_X11" = true ] && [ -d "$SRC_DIR/xsrc" ]; then
        rm -rf "$XSRC_DIR" 2>/dev/null || true
        ln -sf "$SRC_DIR/xsrc" "$XSRC_DIR"
    fi
}

fetch_current_git() {
    log "Downloading CURRENT via git (shallow clone, branch: ${CURRENT_BRANCH})..."
    update_repo() {
        local dir="$1"
        local url="$2"
        local git_opts=( -c http.postBuffer=524288000 -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=600 )
        if [ -d "$dir/.git" ]; then
            ( cd "$dir" && git "${git_opts[@]}" fetch --depth 1 origin "$CURRENT_BRANCH" && git reset --hard "origin/$CURRENT_BRANCH" )
        else
            git "${git_opts[@]}" clone --depth 1 --single-branch -b "$CURRENT_BRANCH" "$url" "$dir"
        fi
    }
    update_repo "$SRC_DIR" "https://github.com/NetBSD/src.git"
    [ "$BUILD_X11" = true ] && update_repo "$XSRC_DIR" "https://github.com/NetBSD/xsrc.git"
}

fetch_repos() {
    if [ "$VERSION_TYPE" = "stable" ]; then
        fetch_stable_tarballs
    else
        fetch_current_git
    fi
}

# -----------------------------------------------------------------------------
# BUILD (RELEASE + MEDIA)
# -----------------------------------------------------------------------------
# Determina qual alvo de mídia usar para cada MACHINE.
# iso-image: CD/DVD (amd64, i386, sparc64, xen)
# live-image: imagem inicializável (hpcarm, etc.)
# disk-image: imagem de disco (evbarm via gzimg, evbmips, evbppc)
# none: sem mídia pronta; só release (sets)
media_target_for() {
    case "$1" in
        amd64|i386|sparc64|xen) echo "iso-image" ;;
        hpcarm)                 echo "live-image" ;;
        evbarm|evbmips|evbppc)  echo "disk-image" ;;
        *)                      echo "none" ;;
    esac
}

build_netbsd() {
    log "Starting build for $TARGET_MACHINE with $BUILD_JOBS parallel jobs"
    cd "$SRC_DIR"

    local BUILD_CMD="./build.sh -U -u -j $BUILD_JOBS -m $TARGET_MACHINE -O $OBJ_DIR -D $DEST_DIR -R $REL_DIR"
    [ "$BUILD_X11" = true ] && BUILD_CMD="$BUILD_CMD -x -X $XSRC_DIR"

    if [ "$USE_CLANG" = true ]; then
        BUILD_CMD="$BUILD_CMD -V USE_CLANG=yes -V MKLLVM=yes -V HAVE_LLVM=yes -V MKGCC=no"
        log "Compiler: Clang/LLVM"
    else
        log "Compiler: GCC"
    fi

    if [ "$TARGET_MACHINE" = "amd64" ] && [ "$ENABLE_32BIT" = true ]; then
        BUILD_CMD="$BUILD_CMD -V MKCOMPAT=yes"
        if [ "$BUILD_X11" = true ]; then
            BUILD_CMD="$BUILD_CMD -V MKCOMPATX11=yes"
        fi
        log "MKCOMPAT=yes (base32/comp32 enabled)"
    fi

    export MAKEFLAGS="-j${BUILD_JOBS}"

    log "Generating release..."
    $BUILD_CMD release || error "Release failed"

    local media_target
    media_target=$(media_target_for "$TARGET_MACHINE")

    case "$media_target" in
        iso-image)
            log "Generating original ISO (no modifications)..."
            $BUILD_CMD iso-image || error "ISO image generation failed"
            ;;
        live-image)
            log "Generating live image (iso-image not supported for $TARGET_MACHINE)..."
            $BUILD_CMD live-image || error "Live image generation failed"
            ;;
        disk-image)
            log "Generating disk image (iso-image not supported for $TARGET_MACHINE)..."
            $BUILD_CMD disk-image=arm64 || warn "disk-image target may vary by board; check $REL_DIR"
            ;;
        none)
            warn "No ready-made media target for $TARGET_MACHINE. Release artifacts are in: $REL_DIR"
            ;;
    esac
}

# -----------------------------------------------------------------------------
# BACKUP AND FINAL CLEANUP
# -----------------------------------------------------------------------------
backup_repo() {
    local repo_path="$1"
    local repo_name="$2"
    if [ -d "$repo_path" ]; then
        local backup_file="$DIST_DIR/${repo_name}-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
        log "Backing up $repo_name to $backup_file"
        tar -czf "$backup_file" -C "$(dirname "$repo_path")" "$(basename "$repo_path")"
    fi
}

final_cleanup() {
    echo ""
    read -r -p "Remove destdir and release directories (keep media)? (y/N) " resp
    if [[ "$resp" =~ ^[Yy]$ ]]; then
        rm -rf "$DEST_DIR" "$REL_DIR"
        log "destdir and release removed."
    fi
    read -r -p "Remove obj directory as well (force full rebuild next time)? (y/N) " resp_obj
    if [[ "$resp_obj" =~ ^[Yy]$ ]]; then
        rm -rf "$OBJ_DIR"
        log "obj directory removed."
    fi
}

# -----------------------------------------------------------------------------
# MAIN
# -----------------------------------------------------------------------------
main() {
    show_welcome
    select_version
    select_architecture
    ask_x11

    if [ "$TARGET_MACHINE" = "amd64" ]; then
        ask_32bit_compat
    else
        log "32-bit compatibility ignored for $TARGET_MACHINE"
        ENABLE_32BIT=false
    fi

    ask_compiler
    ask_verification_options

    check_disk_space
    clean_previous_builds
    install_dependencies
    fetch_repos
    build_netbsd

    # Copia artefatos de mídia para DIST_DIR (ISO, live img, disk img)
    local found_media=false
    local f
    for f in "$REL_DIR"/images/*.iso "$REL_DIR"/images/*.img.gz; do
        [ -f "$f" ] || continue
        cp "$f" "$DIST_DIR/"
        log "Copied media: $DIST_DIR/$(basename "$f")"
        found_media=true
    done
    if [ "$found_media" = false ]; then
        # Fallback: procurar gzimg (evbarm)
        for f in "$REL_DIR"/*/binary/gzimg/*.img.gz; do
            [ -f "$f" ] || continue
            cp "$f" "$DIST_DIR/"
            log "Copied disk image: $DIST_DIR/$(basename "$f")"
            found_media=true
        done
    fi
    if [ "$found_media" = false ]; then
        warn "No media image found in $REL_DIR (expected for some architectures)."
    fi

    read -r -p "Create backups of source repositories (src, xsrc)? (y/N) " backup_choice
    if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
        backup_repo "$SRC_DIR" "netbsd-src"
        [ "$BUILD_X11" = true ] && backup_repo "$XSRC_DIR" "netbsd-xsrc"
    fi

    final_cleanup

    END_TIME=$(date +%s)
    ELAPSED=$((END_TIME - START_TIME))
    log "Total build time: $((ELAPSED/60)) minutes and $((ELAPSED%60)) seconds"
    log "Script finished! Artifacts available in $DIST_DIR"
}

main "$@"
