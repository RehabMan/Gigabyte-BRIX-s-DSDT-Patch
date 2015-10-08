## Gigabyte "BRIX s" DSDT patches by RehabMan

This set of patches/makefile can be used to patch your Haswell Gigabyte BRIX DSDT/SSDTs.  It relies heavily on already existing laptop DSDT patches at github here: https://github.com/RehabMan/Laptop-DSDT-Patch.. There are also post install scripts that can be used to create and install the kexts the are required for this laptop series.

The current repository actually uses only on-the-fly patches vai config.plist and an additional SSDT, SSDT-HACK.aml.

Please refer to this guide thread on tonymacx86.com for a step-by-step process, feedback, and questions:

http://www.tonymacx86.com/yosemite-desktop-guides/167933-guide-gigabyte-brix-s-using-clover-uefi-gb-bxi5h-4200-a.html


### Change Log:

2015-10-07 

- Use Arbitrary injection (new feature in Clover, working with my fixes to Clover v3279+)

- use DSDT/Patches for IGPU/HDAU renames (DSDT/Patches faster with my fixes to Clover v3279+)


2015-07-07

- Cleanup and transition to on-the-fly patching for this mini desktop PC.


2015-06-18

- Initial creation based on Lenovo u430 scripts.
