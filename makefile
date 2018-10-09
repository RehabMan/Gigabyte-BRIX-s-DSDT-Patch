# makefile

#
# Patches/Installs/Builds DSDT patches for Gigabyte BRIX
#
# Created by RehabMan 
#

# set build products
BUILDDIR=./build
AML_PRODUCTS=$(BUILDDIR)/SSDT-HACK.aml
PRODUCTS=$(AML_PRODUCTS)

IASLFLAGS=-ve
IASL=iasl

.PHONY: all
all: $(PRODUCTS)

$(BUILDDIR)/SSDT-HACK.aml: SSDT-HACK.dsl SSDT-XOSI.dsl SSDT-IGPU.dsl SSDT-USB.dsl SSDT-EC.dsl
	$(IASL) $(IASLFLAGS) -p $@ $<

.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.dsl $(BUILDDIR)/*.aml

.PHONY: install
install: $(AML_PRODUCTS)
	$(eval EFIDIR:=$(shell ./mount_efi.sh))
	rm -f "$(EFIDIR)"/EFI/CLOVER/ACPI/patched/DSDT.aml
	rm -f "$(EFIDIR)"/EFI/CLOVER/ACPI/patched/SSDT-*.aml $(EFIDIR)/EFI/CLOVER/ACPI/patched/SSDT.aml
	cp $(AML_PRODUCTS) "$(EFIDIR)"/EFI/CLOVER/ACPI/patched

