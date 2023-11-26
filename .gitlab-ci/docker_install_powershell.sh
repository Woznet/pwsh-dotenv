#!/bin/bash

# We need to install dependencies only for Docker
[[ ! -e /.dockerenv ]] && exit 0

set -eux

apt-get update

apt-get install -y \
    git \
    unzip \
    curl \
    gnupg \

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --yes --dearmor --output /usr/share/keyrings/microsoft.gpg

sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/microsoft-debian-bullseye-prod bullseye main" > /etc/apt/sources.list.d/microsoft.list'

apt-get update

apt-get install -y \
    powershell

pwsh -NoLogo -Command Set-PSRepository PSGallery -InstallationPolicy Trusted
pwsh -NoLogo -Command Install-Module -Name Pester -ErrorAction Stop
# pwsh -NoLogo -Command Install-Module PSScriptAnalyzer -ErrorAction Stop
