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
    echo -e "${YELLOW}╔═════════════════════════════════════════════════════════[...]
    echo -e "${YELLOW}║                         ${GREEN}NetBSD Builder Ultimate     ${YELLOW}                         ║${NC}"
    echo -e "${YELLOW}║                                                                              ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${YELLOW}     ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}▓▓▒░${BLUE}               NetBSD  ${GREEN}\"Of course it runs NetBSD\"${BLUE}             ${CYAN}░▒▓▓${YELLOW}     ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓${YELLOW}     ║${NC}"
    echo -e "${YELLOW}║                                                                              ║${NC}"
    echo -e "${YELLOW}║   ${MAGENTA}Welcome to the personalized NetBSD ISO builder!${YELLOW}                            ║${NC}"
    echo -e "${YELLOW}║   This script will guide you through the options and start the build.        ║${NC}"
    echo -e "${YELLOW}║   The process can take several hours. Please be patient.                     ║${NC}"
    echo -e "${YELLOW}║                                                                              ║${NC}"
    echo -e "${YELLOW}║   ${CYAN}Note: The generated ISO is original (no extra modifications).${YELLOW}              ║${NC}"
    echo -e "${YELLOW}║   To add pkgsrc, do it manually after installation.                          ║${NC}"
    echo -e "${YELLOW}╚═════════════════════════════════════════════════════════[...]
    echo ""
    read -p "$(echo -e ${CYAN}▶ Press ENTER to start the build...${NC})" dummy
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
STABLE_VERSION="${STABLE_VERSION:-11.0}"
CURRENT_BRANCH="${CURRENT_BRANCH:-trunk}"
BUILD_JOBS=1

if command -v nproc >/dev/null 2>&1; then
    BUILD_JOBS=$(nproc)
elif command -v sysctl >/dev/null 2>&1; then
    BUILD_JOBS=$(sysctl -n hw.ncpu 2>/dev/null || echo 1)
fi

mkdir -p "$BASE_DIR" "$DIST_DIR" "$OBJ_DIR" "$DEST_DIR" "$REL_DIR"
START_TIME=$(date +%s)

# -----------------------------------------------------------------------------
# INTERACTIVE CONFIGURATION FUNCTIONS
# -----------------------------------------------------------------------------
select_version() {
    echo ""
    echo "============================================================"
    echo " Select NetBSD version:"
    echo " 1) STABLE (official tarballs, fast)"
    echo " 2) CURRENT (git, unstable)"
    echo "============================================================"
    while true; do
        read -p "Choice (1 or 2) [1]: " ver_choice
        ver_choice="${ver_choice:-1}"
        case "$ver_choice" in
            1) VERSION_TYPE="stable"; break ;;
            2) VERSION_TYPE="current"; break ;;
            *) warn "Invalid option." ;;
        esac
    done
    log "Version: $VERSION_TYPE"
}

select_architecture() {
    echo ""
    echo "Available architectures (Tier I):"
    echo " 1) amd64    2) i386     3) evbarm   4) evbmips"
    echo " 5) evbppc   6) hpcarm   7) sparc64  8) xen"
    while true; do
        read -p "Choice (1-8) [1]: " choice
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
        read -p "Build X11 (graphical interface)? (y/N) " resp
        resp="${resp,,}"
        if [[ "$resp" =~ ^(y|yes)$ ]]; then
            BUILD_X11=true
            break
        elif [[ "$resp" =~ ^(n|no|)$ ]]; then
            BUILD_X11=false
            break
        else
            warn "Answer y or n."
        fi
    done
}

ask_32bit_compat() {
    # Only for amd64
    while true; do
        echo ""
        read -p "Include 32-bit application support (base32/comp32)? (y/N) " resp
        resp="${resp,,}"
        if [[ "$resp" =~ ^(y|yes)$ ]]; then
            ENABLE_32BIT=true
            log "✅ 32-bit compatibility will be included (MKCOMPAT=yes)"
            break
        elif [[ "$resp" =~ ^(n|no|)$ ]]; then
            ENABLE_32BIT=false
            log "❌ 32-bit compatibility will NOT be included"
            break
        else
            warn "Answer y or n."
        fi
    done
}

ask_compiler() {
    while true; do
        echo ""
        read -p "Use Clang as default compiler instead of GCC? (y/N) " resp
        resp="${resp,,}"
        if [[ "$resp" =~ ^(y|yes)$ ]]; then
            USE_CLANG=true
            log "✅ Compilation with Clang/LLVM"
            break
        elif [[ "$resp" =~ ^(n|no|)$ ]]; then
            USE_CLANG=false
            log "❌ Compilation with GCC (default)"
            break
        else
            warn "Answer y or n."
        fi
    done
}

# -----------------------------------------------------------------------------
# CHECKS AND DEPENDENCIES (MULTI-PLATFORM)
# -----------------------------------------------------------------------------
check_disk_space() {
    log "Checking disk space (minimum 20GB)..."
    local avail=$(df --output=avail "$BASE_DIR" | tail -1 | awk '{print int($1/1024/1024)}')
    if [ "$avail" -lt 20 ]; then
        error "Only ${avail}GB free (minimum 20GB)."
    fi
    log "Disk space OK: ${avail}GB available."
}

run_privileged() {
    local cmd="$1"
    if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
        sudo sh -c "$cmd"
    elif command -v su >/dev/null 2>&1; then
        su -c "$cmd"
    else
        error "Unable to execute '$cmd' as root. Install sudo or run manually."
    fi
}

install_dependencies() {
    log "Detecting operating system and package manager..."

    # macOS
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

    # Linux / BSD
    if command -v apt-get >/dev/null 2>&1; then
        log "apt package manager detected (Debian/Ubuntu)"
        run_privileged "apt-get update && apt-get install -y build-essential bison flex libssl-dev libelf-dev bc gawk wget tar xz-utils bzip2 xorriso grub-pc-bin grub-efi-amd64-bin mtools cpio pkg-config python3 texinfo rsync unzip patch zlib cmake git curl"

    elif command -v dnf >/dev/null 2>&1; then
        log "dnf package manager detected (Fedora/RHEL)"
        run_privileged "dnf groupinstall -y 'Development Tools' && dnf install -y bison flex openssl-devel elfutils-libelf-devel bc gawk wget tar xz bzip2 xorriso grub2-tools grub2-pc mtools cpio pkgconf python3 texinfo rsync unzip patch zlib cmake git curl"

    elif command -v yum >/dev/null 2>&1; then
        log "yum package manager detected (CentOS/RHEL 7)"
        run_privileged "yum groupinstall -y 'Development Tools' && yum install -y bison flex openssl-devel elfutils-libelf-devel bc gawk wget tar xz bzip2 xorriso grub2-tools mtools cpio pkgconf python3 texinfo rsync unzip patch zlib cmake git curl"

    elif command -v pacman >/dev/null 2>&1; then
        log "pacman package manager detected (Arch Linux)"
        run_privileged "pacman -S --needed --noconfirm base-devel bison flex openssl libelf bc gawk wget tar xz bzip2 libisoburn grub mtools cpio pkg-config python texinfo rsync unzip patch zlib cmake git curl"

    elif command -v pkg >/dev/null 2>&1; then
        log "pkg package manager detected (FreeBSD)"
        run_privileged "pkg update && pkg install -y gcc bison flex openssl elfutils bc gawk wget tar xz bzip2 xorriso grub2-tools mtools cpio pkgconf python3 texinfo rsync unzip patch zlib cmake git curl"

    elif command -v pkgin >/dev/null 2>&1; then
        log "pkgin package manager detected (NetBSD)"
        if ! command -v pkgin >/dev/null 2>&1; then
            echo -e "${YELLOW}pkgin not found. Installing via pkg_add...${NC}"
            run_privileged "pkg_add pkgin" || error "Failed to install pkgin"
        fi
        run_privileged "pkgin update && pkgin install -y gcc bison flex openssl elfutils bc gawk wget tar xz bzip2 xorriso grub2 mtools cpio pkg-config python37 texinfo rsync unzip patch zlib cmake git curl"

    else
        warn "No known package manager found. Install dependencies manually."
    fi

    log "Host dependencies checked/installed."
}

clean_previous_builds() {
    read -p "Remove previous destdir and release directories? (y/N) " resp
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
            wget -c "${base_url}/${tgz}" -O "$BASE_DIR/$tgz" || error "Failed to download $tgz"
        fi
    done
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
        local git_opts=(-c http.postBuffer=524288000 -c http.lowSpeedLimit=1000 -c http.lowSpeedTime=600)
        if [ -d "$dir/.git" ]; then
            cd "$dir" && git "${git_opts[@]}" fetch --depth 1 origin "$CURRENT_BRANCH" && git reset --hard "origin/$CURRENT_BRANCH"
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
# BUILD (RELEASE + ISO-IMAGE)
# -----------------------------------------------------------------------------
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
        BUILD_CMD="$BUILD_CMD -V MKCOMPAT=yes -V MKCOMPATX11=yes"
        log "MKCOMPAT=yes (base32/comp32 enabled)"
    fi

    export MAKEFLAGS="-j $BUILD_JOBS"

    log "Generating release..."
    $BUILD_CMD release || error "Release failed"

    log "Generating original ISO (no modifications)..."
    $BUILD_CMD iso-image || error "ISO image generation failed"
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
    read -p "Remove destdir and release directories (keep ISO)? (y/N) " resp
    if [[ "$resp" =~ ^[Yy]$ ]]; then
        rm -rf "$DEST_DIR" "$REL_DIR"
        log "destdir and release removed."
    fi
    read -p "Remove obj directory as well (force full rebuild next time)? (y/N) " resp_obj
    if [[ "$resp_obj" =~ ^[Yy]$ ]]; then
        rm -rf "$OBJ_DIR"
        log "obj directory removed."
    fi
}

# -----------------------------------------------------------------------------
# MAIN EXECUTION
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

    check_disk_space
    clean_previous_builds
    install_dependencies
    fetch_repos
    build_netbsd

    # Copy the generated ISO to DIST_DIR
    local iso_file=$(find "$REL_DIR/images" -name "*.iso" 2>/dev/null | head -n 1)
    if [ -f "$iso_file" ]; then
        cp "$iso_file" "$DIST_DIR/"
        log "✅ Original ISO copied to: $DIST_DIR/$(basename "$iso_file")"
    else
        warn "ISO file not found."
    fi

    read -p "Create backups of source repositories (src, xsrc)? (y/N) " backup_choice
    if [[ "$backup_choice" =~ ^[Yy]$ ]]; then
        backup_repo "$SRC_DIR" "netbsd-src"
        [ "$BUILD_X11" = true ] && backup_repo "$XSRC_DIR" "netbsd-xsrc"
    fi

    final_cleanup

    END_TIME=$(date +%s)
    ELAPSED=$((END_TIME - START_TIME))
    log "Total build time: $((ELAPSED/60)) minutes and $((ELAPSED%60)) seconds"
    log "Script finished! ISO available in $DIST_DIR"
}

main "$@"
