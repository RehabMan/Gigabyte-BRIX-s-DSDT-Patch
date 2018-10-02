#!/bin/bash
#set -x

EXCEPTIONS=
ESSENTIAL="AppleALC.kext"

# include subroutines
DIR=$(dirname ${BASH_SOURCE[0]})
source "$DIR/tools/_install_subs.sh"

warn_about_superuser

# install tools
install_tools

# remove old kexts
remove_deprecated_kexts
# EHCI is disabled, so no need for FakePCIID_XHCIMux.kext
remove_kext FakePCIID_XHCIMux.kext
# using AppleALC.kext, remove CodecCommander.kext and patched zml.zlib files
remove_kext CodecCommander.kext
sudo rm -f /System/Library/Extensions/AppleHDA.kext/Contents/Resources/*.zml.zlib

# install required kexts
install_download_kexts
install_brcmpatchram_kexts

# all kexts are now installed, so rebuild cache
rebuild_kernel_cache

# update kexts on EFI/CLOVER/kexts/Other
update_efi_kexts

#EOF
