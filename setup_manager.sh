#!/bin/bash

set -e

BACKUP_DIR="$HOME/artix_setup_backup"
BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
CONFIG_BACKUP="$BACKUP_DIR/configs"
SCRIPT_DIR="$BACKUP_DIR/scripts"

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

backup_system() {
  print_header "BACKUP SYSTÈME - $BACKUP_DATE"

  mkdir -p "$CONFIG_BACKUP"
  mkdir -p "$SCRIPT_DIR"

  print_info "Sauvegarde dans: $BACKUP_DIR"
  echo ""

  print_info "1/8 Sauvegarde liste des packages..."
  pacman -Qe >"$BACKUP_DIR/packages_explicit.txt"
  pacman -Q >"$BACKUP_DIR/packages_all.txt"
  pacman -Qm >"$BACKUP_DIR/packages_aur.txt" 2>/dev/null || touch "$BACKUP_DIR/packages_aur.txt"
  print_success "Packages sauvegardés"

  print_info "2/8 Sauvegarde configs système..."

  # Sway
  if [ -d "$HOME/.config/sway" ]; then
    cp -r "$HOME/.config/sway" "$CONFIG_BACKUP/"
    print_success "Config Sway"
  fi

  # Waybar
  if [ -d "$HOME/.config/waybar" ]; then
    cp -r "$HOME/.config/waybar" "$CONFIG_BACKUP/"
    print_success "Config Waybar"
  fi

  # Foot
  if [ -d "$HOME/.config/foot" ]; then
    cp -r "$HOME/.config/foot" "$CONFIG_BACKUP/"
    print_success "Config Foot"
  fi

  # Qutebrowser
  if [ -d "$HOME/.config/qutebrowser" ]; then
    cp -r "$HOME/.config/qutebrowser" "$CONFIG_BACKUP/"
    print_success "Config Qutebrowser"
  fi

  # Neovim/LazyVim
  if [ -d "$HOME/.config/nvim" ]; then
    cp -r "$HOME/.config/nvim" "$CONFIG_BACKUP/"
    print_success "Config LazyVim"
  fi

  # Swaylock
  if [ -d "$HOME/.config/swaylock" ]; then
    cp -r "$HOME/.config/swaylock" "$CONFIG_BACKUP/"
    print_success "Config Swaylock"
  fi

  # Mako
  if [ -d "$HOME/.config/mako" ]; then
    cp -r "$HOME/.config/mako" "$CONFIG_BACKUP/"
    print_success "Config Mako"
  fi

  # Fontconfig
  if [ -d "$HOME/.config/fontconfig" ]; then
    cp -r "$HOME/.config/fontconfig" "$CONFIG_BACKUP/"
    print_success "Config Fontconfig"
  fi

  # Pulse (PipeWire)
  if [ -d "$HOME/.config/pulse" ]; then
    cp -r "$HOME/.config/pulse" "$CONFIG_BACKUP/"
    print_success "Config PipeWire/Pulse"
  fi

  # VSCode/Code
  if [ -d "$HOME/.config/Code" ]; then
    cp -r "$HOME/.config/Code" "$CONFIG_BACKUP/"
    print_success "Config VSCode"
  fi

  # Go
  if [ -d "$HOME/.config/go" ]; then
    cp -r "$HOME/.config/go" "$CONFIG_BACKUP/"
    print_success "Config Go"
  fi

  # Yay
  if [ -d "$HOME/.config/yay" ]; then
    cp -r "$HOME/.config/yay" "$CONFIG_BACKUP/"
    print_success "Config Yay"
  fi

  # 3. Dotfiles
  print_info "3/8 Sauvegarde dotfiles..."
  [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$CONFIG_BACKUP/"
  [ -f "$HOME/.zprofile" ] && cp "$HOME/.zprofile" "$CONFIG_BACKUP/"
  [ -f "$HOME/.zsh_history" ] && cp "$HOME/.zsh_history" "$CONFIG_BACKUP/"
  [ -f "$HOME/.zsh_compdump" ] && cp "$HOME/.zsh_compdump" "$CONFIG_BACKUP/"
  [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$CONFIG_BACKUP/"
  [ -f "$HOME/.bash_profile" ] && cp "$HOME/.bash_profile" "$CONFIG_BACKUP/"
  [ -f "$HOME/.bash_history" ] && cp "$HOME/.bash_history" "$CONFIG_BACKUP/"
  [ -f "$HOME/.bash_logout" ] && cp "$HOME/.bash_logout" "$CONFIG_BACKUP/"
  [ -f "$HOME/.vimrc" ] && cp "$HOME/.vimrc" "$CONFIG_BACKUP/"
  [ -f "$HOME/.gitconfig" ] && cp "$HOME/.gitconfig" "$CONFIG_BACKUP/"
  [ -f "$HOME/.fehbg" ] && cp "$HOME/.fehbg" "$CONFIG_BACKUP/"
  [ -f "$HOME/.wget-hsts" ] && cp "$HOME/.wget-hsts" "$CONFIG_BACKUP/"
  print_success "Dotfiles sauvegardés"

  # 4. Fonts
  print_info "4/8 Sauvegarde fonts..."
  if [ -d "$HOME/.local/share/fonts" ]; then
    cp -r "$HOME/.local/share/fonts" "$CONFIG_BACKUP/"
    print_success "Fonts utilisateur"
  fi

  # 5. Scripts utilisateur
  print_info "5/8 Sauvegarde scripts..."
  if [ -d "$HOME/.local/bin" ]; then
    cp -r "$HOME/.local/bin" "$CONFIG_BACKUP/"
    print_success "Scripts locaux"
  fi

  # 6. NVM et NPM
  print_info "6/8 Sauvegarde NVM/NPM..."
  if [ -d "$HOME/.nvm" ]; then
    # Sauvegarde juste la config, pas les modules
    [ -f "$HOME/.nvm/alias/default" ] && mkdir -p "$CONFIG_BACKUP/.nvm/alias" && cp "$HOME/.nvm/alias/default" "$CONFIG_BACKUP/.nvm/alias/"
    print_success "Config NVM"
  fi
  if [ -d "$HOME/.npm" ]; then
    # Sauvegarde liste des packages globaux npm
    npm list -g --depth=0 >"$BACKUP_DIR/npm_global_packages.txt" 2>/dev/null || touch "$BACKUP_DIR/npm_global_packages.txt"
    print_success "Liste packages NPM globaux"
  fi

  # 7. Infos système et services
  print_info "7/8 Sauvegarde infos système..."
  uname -a >"$BACKUP_DIR/system_info.txt"
  cat /etc/os-release >>"$BACKUP_DIR/system_info.txt"

  # Services runit activés
  if [ -d "/etc/runit/runsvdir/default" ]; then
    ls -la /etc/runit/runsvdir/default/ >"$BACKUP_DIR/runit_services.txt"
    print_success "Services runit"
  fi

  # 8. Crée script de restore automatique
  print_info "8/8 Création script de restore..."
  create_restore_script
  print_success "Script de restore créé"

  echo ""
  print_header "BACKUP TERMINÉ"
  echo ""
  print_success "Backup sauvegardé dans: $BACKUP_DIR"
  print_info "Pour restaurer: cd $BACKUP_DIR && ./restore.sh"
  echo ""
}

create_restore_script() {
  cat >"$BACKUP_DIR/restore.sh" <<'RESTORE_SCRIPT'
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
RESTORE_SCRIPT

  chmod +x "$BACKUP_DIR/restore.sh"
}

restore_system() {
  if [ ! -f "$BACKUP_DIR/restore.sh" ]; then
    print_error "Aucun backup trouvé dans $BACKUP_DIR"
    print_info "Lance d'abord: $0 backup"
    exit 1
  fi

  cd "$BACKUP_DIR"
  ./restore.sh
}

show_usage() {
  echo "Usage: $0 [backup|restore|help]"
  echo ""
  echo "Commandes:"
  echo "  backup   - Sauvegarde tout le système"
  echo "  restore  - Restaure depuis le dernier backup"
  echo "  help     - Affiche cette aide"
  echo ""
  echo "Exemple:"
  echo "  $0 backup           # Crée un backup complet"
  echo "  $0 restore          # Restaure depuis backup"
}

case "${1:-}" in
backup)
  backup_system
  ;;
restore)
  restore_system
  ;;
help | --help | -h)
  show_usage
  ;;
*)
  print_error "Commande invalide"
  echo ""
  show_usage
  exit 1
  ;;
esac
