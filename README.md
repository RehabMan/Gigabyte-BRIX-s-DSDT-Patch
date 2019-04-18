## Gigabyte "BRIX s" DSDT patches by RehabMan

This set of patches/makefile can be used to patch your Haswell Gigabyte BRIX DSDT/SSDTs.  It relies heavily on already existing laptop DSDT patches at github here: https://github.com/RehabMan/Laptop-DSDT-Patch.. There are also post install scripts that can be used to create and install the kexts the are required for this laptop series.

The current repository actually uses only on-the-fly patches vai config.plist and an additional SSDT, SSDT-HACK.aml.

Please refer to this guide thread on tonymacx86.com for a step-by-step process, feedback, and questions:

https://www.tonymacx86.com/threads/guide-gigabyte-brix-using-clover-uefi-gb-bxi5h-4200-gb-bxi5-4570r-gb-bxi7-4770r.261710/

### Change Log:

2018-09-01

- switch to AppleALC.kext for audio


2018-01-24

- add preliminary Broadwell support (not tested)

- copy "essential" kexts to EFI/Clover/kexts/Other as part of install_downloads.sh


2015-10-24

- refactor SSDT-HACK into separate SSDTs

- inject graphics with SSDT-IGPU (more flexible and will handle models other than this specific BRIX)


2015-10-17

- use USBInjectAll.kext with custom configuration


2015-10-15

- disable EHCI#1 USB2 controller, use XHCI only


2015-10-01

- install to /L/E on 10.11+


2015-10-07 

- Use Arbitrary injection (new feature in Clover, working with my fixes to Clover v3279+)

- use DSDT/Patches for IGPU/HDAU renames (DSDT/Patches faster with my fixes to Clover v3279+)


2015-07-07

- Cleanup and transition to on-the-fly patching for this mini desktop PC.


2015-06-18

- Initial creation based on Lenovo u430 scripts.
