# makefile

#
# Patches/Installs/Builds DSDT patches for Gigabyte BRIX
#
# Created by RehabMan 
#

BUILDDIR=./build
RESOURCES=./Resources_ALC269
HDAINJECT=AppleHDA_ALC269.kext
HDALAYOUT=layout1

IASLFLAGS=-ve
IASL=iasl

# for now only build SSDT-HACK.aml, not patched set
.PHONY: all
all: $(BUILDDIR)/SSDT-HACK.aml $(HDAINJECT)

$(BUILDDIR)/SSDT-HACK.aml: ./SSDT-HACK.dsl
	$(IASL) $(IASLFLAGS) -p $@ $<

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.dsl $(BUILDDIR)/*.aml

# Clover Install
.PHONY: install
install: $(BUILDDIR)/SSDT-HACK.aml
	$(eval EFIDIR:=$(shell sudo ./mount_efi.sh /))
	cp $(BUILDDIR)/SSDT-HACK.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched/SSDT-HACK.aml

$(HDAINJECT): $(RESOURCES)/ahhcd.plist $(RESOURCES)/layout/Platforms.xml.zlib $(RESOURCES)/layout/$(HDALAYOUT).xml.zlib ./patch_hda.sh
	./patch_hda.sh
	touch $@

$(RESOURCES)/layout/Platforms.xml.zlib: $(RESOURCES)/layout/Platforms.plist /System/Library/Extensions/AppleHDA.kext/Contents/Resources/Platforms.xml.zlib
	./tools/zlib inflate /System/Library/Extensions/AppleHDA.kext/Contents/Resources/Platforms.xml.zlib >/tmp/rm_Platforms.plist
	/usr/libexec/plistbuddy -c "Delete ':PathMaps'" /tmp/rm_Platforms.plist
	/usr/libexec/plistbuddy -c "Merge $(RESOURCES)/layout/Platforms.plist" /tmp/rm_Platforms.plist
	./tools/zlib deflate /tmp/rm_Platforms.plist >$@

$(RESOURCES)/layout/$(HDALAYOUT).xml.zlib: $(RESOURCES)/layout/$(HDALAYOUT).plist
	./tools/zlib deflate $< >$@

.PHONY: update_kernelcache
update_kernelcache:
	sudo touch /System/Library/Extensions
	sudo kextcache -update-volume /

.PHONY: install_hda
install_hda:
	sudo rm -Rf /System/Library/Extensions/$(HDAINJECT)
	sudo cp -R ./$(HDAINJECT) /System/Library/Extensions
	if [ "`which tag`" != "" ]; then sudo tag -a Blue /System/Library/Extensions/$(HDAINJECT); fi
	make update_kernelcache

