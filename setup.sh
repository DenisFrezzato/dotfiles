#!/bin/bash

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin && makepkg -si

mkdir -p .antigen && curl -L git.io/antigen > .antigen/antigen.zsh

yay -S \
  alsa-utils \
  brightessctl \
  chromium \
  clamav \
  dbeaver \
  docker \
  docker-compose \
  dunst \
  emptty \
  firefox \
  github-cli \
  grim \
  inter-font \
  jq \
  kitty \
  libfprint \
  mesa \
  neovim \
  networkmanager \
  otf-fontawesome \
  pipewire-alsa \
  pipewire-pulse \
  postman-bin \
  power-profiles-daemon \
  powertop \
  ranger \
  slurp \
  sway \
  swayidle \
  swaylock \
  ttf-firacode-nerd \
  ttf-fire-code \
  ttf-inconsolata-g \
  ttf-jetbrains-mono \
  udiskie \
  waybar \
  wev \
  wget \
  wireplumber \
  wl-clipboard \
  wofi \
  xdg-desktop-portal-wlr \
  zsh

sudo systemctl enable emptty.service
sudo systemctl enable power-profiles-daemon.service
systemctl enable --user pipewire.socket
systemctl enable --user xdg-desktop-portal

cp -r .config .xkb symbols .zshrc ~/
