// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// ObjectType return values per ACPI spec
#define OBJECTTYPE_INTEGER 1
#define OBJECTTYPE_PACKAGE 4

DefinitionBlock ("SSDT-IGPU.aml", "SSDT", 1, "hack", "igpu", 0x00003000)
{
    External(_SB.PCI0, DeviceObj)
    Scope(_SB.PCI0)
    {
        External(IGPU, DeviceObj)
        Scope(IGPU)
        {
            // need the device-id from PCI_config to inject correct properties
            OperationRegion(IGD4, PCI_Config, 2, 2)
            Field(IGD4, AnyAcc, NoLock, Preserve)
            {
                GDID,16
            }

            // inject properties for integrated graphics on IGPU
            Method(_DSM, 4)
            {
                If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
                Store(Package()
                {
                    // Haswell/HD4200
                    0x0a1e, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4200" },
                        "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                    },
                    // Haswell/HD4400
                    0x0a16, 0x041e, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4400" },
                        "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                    },
                    // Haswell/HD4600 (mobile)
                    0x0416, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4600" },
                        "device-id", Buffer() { 0x12, 0x04, 0x00, 0x00 },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                    },
                    // Haswell/HD4600 (desktop)
                    0x0412, Package()
                    {
                        "model", Buffer() { "Intel HD Graphics 4600" },
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                    },
                    // Haswell/HD5000/HD5100/HD5200
                    0x0a26, 0x0a2e, 0x0d22, 0x0d26, Package()
                    {
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() {  0x03, 0x00, 0x22, 0x0d },
                    },
                    // Broadwell/HD5300/HD5500/HD5600/HD6000 (future)
                    0x161e, 0x1616, 0x1612, 0x1626, 0x162b, Package()
                    {
                        "hda-gfx", Buffer() { "onboard-1" },
                        "AAPL,ig-platform-id", Buffer() { 0x02, 0x00, 0x2b, 0x16 },
                    },
                }, Local4)

                // looking for Local3 in Local4 array
                // Local2 is scratch
                // Local0 is current index
                // Local1 is size of array

                // search for package that matches device-id
                Store(GDID, Local3)
                Store(0, Local0)
                Store(SizeOf(Local4), Local1)
                While (LLess(Local0, Local1))
                {
                    Store(DerefOf(Index(Local4,Local0)), Local2)
                    If (LEqual(OBJECTTYPE_INTEGER, ObjectType(Local2)))
                    {
                        If (LEqual(Local2, Local3)) // matching device-id?
                        {
                            // search for Package that follows
                            Increment(Local0)
                            While (LLess(Local0, Local1)) // should always be found, but...
                            {
                                Store(DerefOf(Index(Local4,Local0)), Local2)
                                If (LEqual(OBJECTTYPE_PACKAGE, ObjectType(Local2)))
                                {
                                    Return (Local2)
                                }
                                Increment(Local0)
                            }
                        }
                    }
                    Increment(Local0)
                }

                // should never happen, but inject nothing in this case
                Return (Package() { })
            }
        }
    }
}

//EOF
