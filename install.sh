#!/bin/bash

config_dir="$HOME/.config"

# Default apps
shell=zsh

##################################################
##						##
##		     methods			##
##						##
##################################################

ask_question() {
  local prompt="$1"
  local default_answer="Y"

  read -p "${prompt} [Y/n] " answer

  if [[ -z "$answer" ]]; then
    answer="$default_answer"
  fi

  [[ "$answer" =~ ^[Yy]$ ]]
}

# Example usage
# if ask_question "Do you want to continue?"; then
#   echo "You chose to continue."
# else
#   echo "You chose not to continue."
# fi

##################################################
##						##
##		 adding folders			##
##						##
##################################################
mkdir -p $HOME/code
mkdir -p $HOME/.local/share/

##################################################
##						##
##		     dotfiles			##
##						##
##################################################

chmod -R 755 configs
chmod -R 755 scripts
chmod -R 755 hardware

#############	    Symlinks 	      ############

# regular
ln -fs $(pwd)/configs/alacritty  $config_dir/alacritty
ln -fs $(pwd)/configs/kmonad     $config_dir/kmonad
ln -fs $(pwd)/configs/nvim       $config_dir/nvim


# Other 
ln -fs $(pwd)/wallpapers	 $HOME/.wallpapers
ln -fs $(pwd)/scripts		 $HOME/.scripts
ln -fs $(pwd)/fonts 		 $HOME/.local/share/fonts
ln -fs $(pwd)/desktopfiles 	 $HOME/.local/share/applications

# Styling (gtk etc)
ln -fs $(pwd)/configs/styling/gtk-3.0	 $HOME/.config/gtk-3.0
ln -fs $(pwd)/configs/styling/xsettingsd $HOME/.config/xsettingsd
ln -fs $(pwd)/configs/styling/gtkrc-2.0	 $HOME/.gtkrc-2.0
ln -fs $(pwd)/configs/styling/icons	 $HOME/.icons

# Shell environments
ln -fs $(pwd)/configs/zshrc	 $HOME/.zshrc
ln -fs $(pwd)/configs/bashrc	 $HOME/.bashrc
ln -fs $(pwd)/configs/profile    $HOME/.profile


# Graphical
ln -s $(pwd)/configs/rofi 	  $config_dir/rofi
ln -s $(pwd)/configs/hypr	 $config_dir/hypr
ln -s $(pwd)/configs/waybar	 $config_dir/waybar

##################################################
##						##
##		Official Packages		##
##						##
##################################################

packages=(

  # Essentials
  "alacritty"
  "ranger"
  "$shell"
  "base-devel"
  "openssh"
  "git"
  "fzf"
  "neovim"
  "tldr"
  "nfs-utils"
  "dmidecode"
  "gnupg" # encryption for secrets etc..
  "starship"

  # Development
  "nodejs"
  "npm"

  # Graphical
  "firefox"
  "rofi"
  "nemo"
  "polkit-kde-agent"
  "bluez-utils"
  "font-manager"

  # Hyprland
  "hyprland"
  "xdg-desktop-portal-hyprland"
  "swaybg"
  "waybar"
  "dunst"
  "wl-clipboard"

)


for pkg in "${packages[@]}"; do
  sudo pacman -Syu --needed --noconfirm $pkg || echo "Failed to install $pkg" >> logfile.txt
done

##################################################
##						##
##		Arch User Repository		##
##						##
##################################################

# Install YAY
if ask_question "Do you want to install YAY?"; then
  git clone https://aur.archlinux.org/yay.git 
  cd yay
  makepkg -si
  cd ..
  rm -rf yay

  # YAY Packages
  if ask_question "Do you want to install jetbrains-toolbox?"; then
    yay -S jetbrains-toolbox
  fi
fi

##################################################
##						##
##		     Scripts			##
##						##
##################################################

# Install kMonad
if ask_question "Do you want to install kmonad?"; then
  ./scripts/setup_scripts/kmonad_setup.sh
fi

# install virtmanager
if ask_question "Do you want to install virtmanager?"; then
./scripts/setup_scripts/virtmanager_install.sh
fi

# Add Nas to fstab
./scripts/setup_scripts/fstab_setup.sh


# SSH auth & change from https to ssh

./scripts/setup_scripts/git_setup.sh

##################################################
##						##
##		     Hardware			##
##						##
##################################################


####     Choose spesific machine configs     ####

if ask_question "Is this machine a Thinkpad T14 AMD Gen3?"; then
  ./hardware/thinkpadT14Gen3.sh
fi


##################################################
##						##
##		     Misc			##
##						##
##################################################

# refresh fonts cache. uncomment if fonts is not added correctly
fc-cache -fv

# Change default shell
chsh -s /bin/$shell

echo 'End of script!'
