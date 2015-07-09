## Gigabyte "BRIX s" DSDT patches by RehabMan

This set of patches/makefile can be used to patch your Haswell Gigabyte BRIX DSDT/SSDTs.  It relies heavily on already existing laptop DSDT patches at github here: https://github.com/RehabMan/Laptop-DSDT-Patch.. There are also post install scripts that can be used to create and install the kexts the are required for this laptop series.

The current repository actually uses only on-the-fly patches vai config.plist and an additional SSDT, SSDT-HACK.aml.

Please refer to this guide thread on tonymacx86.com for a step-by-step process, feedback, and questions:

TBW


### Change Log:

2015-07-07

- Cleanup and transition to on-the-fly patching for this mini desktop PC.


2015-06-18

- Initial creation based on Lenovo u430 scripts.
