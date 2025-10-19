#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}→ $1${NC}"
}

BACKUP_DIR="$(cd "$(dirname "$0")" && pwd)"

print_header "RESTAURATION SYSTÈME ARTIX"
echo ""

if ! grep -q "Artix" /etc/os-release 2>/dev/null; then
    print_error "Ce script doit être exécuté sur Artix Linux"
    exit 1
fi

print_info "Backup trouvé dans: $BACKUP_DIR"
echo ""

read -p "Restaurer le système complet ? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_error "Restauration annulée"
    exit 1
fi

# 1. Installation des packages
print_header "ÉTAPE 1/7 - Installation des packages"
echo ""

if [ -f "$BACKUP_DIR/packages_explicit.txt" ]; then
    print_info "Mise à jour du système..."
    sudo pacman -Syu --noconfirm
    
    print_info "Installation des packages officiels..."
    packages=$(awk '{print $1}' "$BACKUP_DIR/packages_explicit.txt")
    
    for pkg in $packages; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            print_info "Installation: $pkg"
            sudo pacman -S --needed --noconfirm "$pkg" 2>/dev/null || print_error "Échec: $pkg"
        fi
    done
    
    print_success "Packages officiels installés"
fi

# Installation yay si nécessaire
if [ -f "$BACKUP_DIR/packages_aur.txt" ] && [ -s "$BACKUP_DIR/packages_aur.txt" ]; then
    if ! command -v yay &>/dev/null; then
        print_info "Installation de yay..."
        git clone https://aur.archlinux.org/yay.git /tmp/yay
        cd /tmp/yay
        makepkg -si --noconfirm
        cd -
        rm -rf /tmp/yay
        print_success "yay installé"
    fi
    
    print_info "Installation des packages AUR..."
    aur_packages=$(awk '{print $1}' "$BACKUP_DIR/packages_aur.txt")
    for pkg in $aur_packages; do
        if ! pacman -Qi "$pkg" &>/dev/null; then
            print_info "Installation AUR: $pkg"
            yay -S --needed --noconfirm "$pkg" 2>/dev/null || print_error "Échec: $pkg"
        fi
    done
    print_success "Packages AUR installés"
fi

echo ""

# 2. Restauration des configs
print_header "ÉTAPE 2/7 - Restauration des configurations"
echo ""

if [ -d "$BACKUP_DIR/configs" ]; then
    print_info "Restauration des configs..."
    
    # Sway
    if [ -d "$BACKUP_DIR/configs/sway" ]; then
        mkdir -p "$HOME/.config/sway"
        cp -r "$BACKUP_DIR/configs/sway/"* "$HOME/.config/sway/"
        print_success "Sway"
    fi
    
    # Waybar
    if [ -d "$BACKUP_DIR/configs/waybar" ]; then
        mkdir -p "$HOME/.config/waybar"
        cp -r "$BACKUP_DIR/configs/waybar/"* "$HOME/.config/waybar/"
        print_success "Waybar"
    fi
    
    # Foot
    if [ -d "$BACKUP_DIR/configs/foot" ]; then
        mkdir -p "$HOME/.config/foot"
        cp -r "$BACKUP_DIR/configs/foot/"* "$HOME/.config/foot/"
        print_success "Foot"
    fi
    
    # Qutebrowser
    if [ -d "$BACKUP_DIR/configs/qutebrowser" ]; then
        mkdir -p "$HOME/.config/qutebrowser"
        cp -r "$BACKUP_DIR/configs/qutebrowser/"* "$HOME/.config/qutebrowser/"
        print_success "Qutebrowser"
    fi
    
    # Neovim
    if [ -d "$BACKUP_DIR/configs/nvim" ]; then
        mkdir -p "$HOME/.config/nvim"
        cp -r "$BACKUP_DIR/configs/nvim/"* "$HOME/.config/nvim/"
        print_success "LazyVim"
    fi
    
    # Swaylock
    if [ -d "$BACKUP_DIR/configs/swaylock" ]; then
        mkdir -p "$HOME/.config/swaylock"
        cp -r "$BACKUP_DIR/configs/swaylock/"* "$HOME/.config/swaylock/"
        print_success "Swaylock"
    fi
    
    # Mako
    if [ -d "$BACKUP_DIR/configs/mako" ]; then
        mkdir -p "$HOME/.config/mako"
        cp -r "$BACKUP_DIR/configs/mako/"* "$HOME/.config/mako/"
        print_success "Mako"
    fi
    
    # Fontconfig
    if [ -d "$BACKUP_DIR/configs/fontconfig" ]; then
        mkdir -p "$HOME/.config/fontconfig"
        cp -r "$BACKUP_DIR/configs/fontconfig/"* "$HOME/.config/fontconfig/"
        print_success "Fontconfig"
    fi
    
    # Pulse
    if [ -d "$BACKUP_DIR/configs/pulse" ]; then
        mkdir -p "$HOME/.config/pulse"
        cp -r "$BACKUP_DIR/configs/pulse/"* "$HOME/.config/pulse/"
        print_success "PipeWire/Pulse"
    fi
    
    # VSCode
    if [ -d "$BACKUP_DIR/configs/Code" ]; then
        mkdir -p "$HOME/.config/Code"
        cp -r "$BACKUP_DIR/configs/Code/"* "$HOME/.config/Code/"
        print_success "VSCode"
    fi
    
    # Go
    if [ -d "$BACKUP_DIR/configs/go" ]; then
        mkdir -p "$HOME/.config/go"
        cp -r "$BACKUP_DIR/configs/go/"* "$HOME/.config/go/"
        print_success "Go"
    fi
    
    # Yay
    if [ -d "$BACKUP_DIR/configs/yay" ]; then
        mkdir -p "$HOME/.config/yay"
        cp -r "$BACKUP_DIR/configs/yay/"* "$HOME/.config/yay/"
        print_success "Yay"
    fi
fi

echo ""

# 3. Restauration dotfiles
print_header "ÉTAPE 3/7 - Restauration des dotfiles"
echo ""

[ -f "$BACKUP_DIR/configs/.zshrc" ] && cp "$BACKUP_DIR/configs/.zshrc" "$HOME/" && print_success ".zshrc"
[ -f "$BACKUP_DIR/configs/.zprofile" ] && cp "$BACKUP_DIR/configs/.zprofile" "$HOME/" && print_success ".zprofile"
[ -f "$BACKUP_DIR/configs/.zsh_history" ] && cp "$BACKUP_DIR/configs/.zsh_history" "$HOME/" && print_success ".zsh_history"
[ -f "$BACKUP_DIR/configs/.bashrc" ] && cp "$BACKUP_DIR/configs/.bashrc" "$HOME/" && print_success ".bashrc"
[ -f "$BACKUP_DIR/configs/.bash_profile" ] && cp "$BACKUP_DIR/configs/.bash_profile" "$HOME/" && print_success ".bash_profile"
[ -f "$BACKUP_DIR/configs/.bash_history" ] && cp "$BACKUP_DIR/configs/.bash_history" "$HOME/" && print_success ".bash_history"
[ -f "$BACKUP_DIR/configs/.vimrc" ] && cp "$BACKUP_DIR/configs/.vimrc" "$HOME/" && print_success ".vimrc"
[ -f "$BACKUP_DIR/configs/.gitconfig" ] && cp "$BACKUP_DIR/configs/.gitconfig" "$HOME/" && print_success ".gitconfig"
[ -f "$BACKUP_DIR/configs/.fehbg" ] && cp "$BACKUP_DIR/configs/.fehbg" "$HOME/" && print_success ".fehbg"

echo ""

# 4. Restauration fonts
print_header "ÉTAPE 4/7 - Restauration des fonts"
echo ""

if [ -d "$BACKUP_DIR/configs/fonts" ]; then
    mkdir -p "$HOME/.local/share/fonts"
    cp -r "$BACKUP_DIR/configs/fonts/"* "$HOME/.local/share/fonts/"
    fc-cache -fv
    print_success "Fonts restaurées et cache reconstruit"
fi

echo ""

# 5. Restauration scripts
print_header "ÉTAPE 5/7 - Restauration des scripts"
echo ""

if [ -d "$BACKUP_DIR/configs/bin" ]; then
    mkdir -p "$HOME/.local/bin"
    cp -r "$BACKUP_DIR/configs/bin/"* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/"*
    print_success "Scripts restaurés"
fi

echo ""

# 6. NVM et NPM
print_header "ÉTAPE 6/7 - Restauration NVM/NPM"
echo ""

if [ ! -d "$HOME/.nvm" ]; then
    print_info "Installation NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    print_success "NVM installé"
fi

if [ -f "$BACKUP_DIR/configs/.nvm/alias/default" ]; then
    mkdir -p "$HOME/.nvm/alias"
    cp "$BACKUP_DIR/configs/.nvm/alias/default" "$HOME/.nvm/alias/"
    print_success "Config NVM restaurée"
fi

echo ""

# 7. Services runit
print_header "ÉTAPE 7/7 - Configuration des services"
echo ""

print_info "Activation services essentiels..."

if [ ! -L "/etc/runit/runsvdir/default/NetworkManager" ]; then
    sudo ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default/
    print_success "NetworkManager activé"
fi

if [ ! -L "/etc/runit/runsvdir/default/elogind" ]; then
    sudo ln -s /etc/runit/sv/elogind /etc/runit/runsvdir/default/
    print_success "elogind activé"
fi

echo ""
print_header "RESTAURATION TERMINÉE !"
echo ""
print_success "Système restauré avec succès"
print_info "Redémarre pour appliquer tous les changements: sudo reboot"
echo ""
