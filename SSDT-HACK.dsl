// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// A bit experimental, but possible as desktops are much simpler vs. laptops
// Becuase of the minimal patches required, we can do most of the work in
// config.plist and small SSDTs such as this one.

DefinitionBlock("", "SSDT", 2, "hack", "_HACK", 0)
{
    #include "SSDT-XOSI.dsl"
    #include "SSDT-IGPU.dsl"
    #include "SSDT-USB.dsl"
    #include "SSDT-ALC269.dsl"
    #include "SSDT-EC.dsl"
}

//EOF
