#!/bin/bash

set -e

DRIVER_VERSION="575.64"
DRIVER_FILE="NVIDIA-Linux-x86_64-${DRIVER_VERSION}.run"
DRIVER_URL="https://in.download.nvidia.com/XFree86/Linux-x86_64/${DRIVER_VERSION}/${DRIVER_FILE}"
STAGE_FILE="/tmp/.nvidia_installer_stage"

echo "🚀 Starting RTX 5090 Setup Script..."

if [ ! -f "$STAGE_FILE" ]; then
    echo "🧰 Stage 1: Installing Linux Kernel 6.13 and GCC 14"

    sudo add-apt-repository -y ppa:cappelikan/ppa
    sudo apt update && sudo apt full-upgrade -y
    sudo apt install -y mainline
    mainline install 6.13

    sudo apt install -y gcc-14
    sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 14
    sudo update-alternatives --set gcc /usr/bin/gcc-14
    gcc --version

    echo "STAGE=driver" | sudo tee "$STAGE_FILE" > /dev/null

    echo "🔁 Reboot required to continue."
    read -p "Do you want to reboot now? (y/n): " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        sudo reboot
    else
        echo "⚠️ Please reboot manually, then re-run this script."
        exit 1
    fi

else
    echo "🧰 Stage 2: Installing NVIDIA Driver for RTX 5090"

    sudo systemctl isolate multi-user.target || true
    for module in nvidia_drm nvidia_uvm nvidia_modeset nvidia; do
        sudo rmmod $module || true
    done

    if [ ! -f "$DRIVER_FILE" ]; then
        wget "$DRIVER_URL"
    fi

    chmod +x "$DRIVER_FILE"

    sudo ./"$DRIVER_FILE" \
        --silent \
        --dkms \
        --install-libglvnd \
        --no-x-check \
        --no-nouveau-check \
        --no-opengl-files \
        --accept-license \
        --run-nvidia-xconfig \
        --no-questions

    sudo rm -f "$STAGE_FILE"
    echo "✅ Driver installed. Rebooting..."
    sudo reboot
fi

