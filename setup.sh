#!/bin/bash

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin && makepkg -si
rm -rf yay-bin

yay -S \
  alsa-utils \
  brightnessctl \
  chromium \
  clamav \
  curl \
  dbeaver \
  docker \
  docker-compose \
  dunst \
  emptty \
  firefox \
  fprintd \
  github-cli \
  grim \
  htop \
  inter-font \
  jq \
  kitty \
  libfprint \
  linux-headers
  mesa \
  neovim \
  networkmanager \
  openssh \
  otf-fontawesome \
  pipewire-alsa \
  pipewire-pulse \
  postman-bin \
  power-profiles-daemon \
  powertop \
  ranger \
  reflector \
  rofi-wayland \
  rsync \
  slurp \
  sway \
  swayidle \
  swaylock \
  ttf-firacode-nerd \
  ttf-fire-code \
  ttf-inconsolata-g \
  ttf-jetbrains-mono \
  udiskie \
  unzip \
  waybar \
  wev \
  wget \
  wireplumber \
  wl-clipboard \
  xdg-desktop-portal-wlr \
  zsh

mkdir -p ~/.antigen && curl -L git.io/antigen > ~/.antigen/antigen.zsh
sudo systemctl enable emptty.service
sudo systemctl enable power-profiles-daemon.service
systemctl enable --user pipewire.socket
systemctl enable --user xdg-desktop-portal
sudo reflector --latest 15 --sort rate --save /etc/pacman.d/mirrorlist

cp -r .config .xkb symbols .zshrc ~
