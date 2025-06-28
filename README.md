# RTX 5090 Ubuntu Driver Auto Installer (Blackwell Architecture)

🚀 This project provides a complete automated installer script for NVIDIA GeForce RTX 5090 GPUs on Ubuntu Linux.
It handles kernel updates, GCC configuration, and silent NVIDIA driver installation — all in a single click.

---

## ✅ Supported Systems

- **GPU:** NVIDIA GeForce RTX 5090 (Blackwell)
- **OS:** Ubuntu 22.04 or later (64-bit)
- **Kernel:** Linux 6.13 or later (auto-installed)
- **Compiler:** GCC 14 (auto-installed)

---

## 📜 Files Included

| File Name                     | Description                                               |
|------------------------------|-----------------------------------------------------------|
| `install_rtx5090_full.sh`    | Auto-installs kernel, GCC, and NVIDIA driver              |
| `rtx5090_driver_install_steps.txt` | Manual step-by-step version of installation         |

---

## ⚙️ What the Script Does

1. Installs Linux kernel `6.13` using `mainline`
2. Installs and configures `GCC 14`
3. Downloads and installs the official NVIDIA driver (e.g. `575.64`)
4. Automatically reboots at proper points
5. No interactive prompts (silent install)

---

## 🚀 Manual Installation Commands

```bash
# Step 1: Install Kernel 6.13 and GCC 14
sudo add-apt-repository -y ppa:cappelikan/ppa
sudo apt update && sudo apt full-upgrade -y
sudo apt install -y mainline
mainline install 6.13

sudo apt install -y gcc-14
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-14 14
sudo update-alternatives --set gcc /usr/bin/gcc-14
gcc --version

# Step 2: Reboot into new kernel
sudo reboot

# Step 3: Stop GUI and remove NVIDIA modules
sudo systemctl isolate multi-user.target
sudo rmmod nvidia_drm || true
sudo rmmod nvidia_uvm || true
sudo rmmod nvidia_modeset || true
sudo rmmod nvidia || true

# Step 4: Download and install NVIDIA driver
wget https://in.download.nvidia.com/XFree86/Linux-x86_64/575.64/NVIDIA-Linux-x86_64-575.64.run
chmod +x NVIDIA-Linux-x86_64-575.64.run

sudo ./NVIDIA-Linux-x86_64-575.64.run \
    --silent \
    --dkms \
    --install-libglvnd \
    --no-x-check \
    --no-nouveau-check \
    --no-opengl-files \
    --accept-license \
    --run-nvidia-xconfig \
    --no-questions

# Step 5: Final reboot
sudo reboot

# Check Driver
nvidia-smi
```

---

## 🎥 Video Inspiration

I got inspiration for this setup from this YouTube video:

[![Watch on YouTube](https://img.youtube.com/vi/o5deOXLDpZw/0.jpg)](https://www.youtube.com/watch?v=o5deOXLDpZw)

> 🔗 [Watch: How to Install NVIDIA Driver on Ubuntu for RTX 5090](https://www.youtube.com/watch?v=o5deOXLDpZw)

Big thanks to the original creator for walking through the manual install steps!

---
