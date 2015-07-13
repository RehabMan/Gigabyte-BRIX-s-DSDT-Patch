// Instead of providing patched DSDT/SSDT, just include a single SSDT
// and do the rest of the work in config.plist

// A bit experimental, but possible as desktops are much simpler vs. laptops
// Becuase of the minimal patches required, we can do most of the work in
// config.plist and small SSDTs such as this one.

DefinitionBlock ("SSDT-HACK.aml", "SSDT", 1, "hack", "hack", 0x00003000)
{
    External(_SB.PCI0, DeviceObj)
    External(_SB.PCI0.B0D3._ADR, IntObj)
    External(_SB.PCI0.GFX0._ADR, IntObj)
    External(_SB.PCI0.EHC1, DeviceObj)
    External(_SB.PCI0.EHC2, DeviceObj)
    External(_SB.PCI0.XHC, DeviceObj)
 
    // All _OSI calls in DSDT are routed to XOSI...
    // XOSI simulates "Windows 2009" (which is Windows 7)
    // Note: According to ACPI spec, _OSI("Windows") must also return true
    //  Also, it should return true for all previous versions of Windows.
    Method(XOSI, 1)
    {
        // simulation targets
        // source: (google 'Microsoft Windows _OSI')
        //  http://download.microsoft.com/download/7/E/7/7E7662CF-CBEA-470B-A97E-CE7CE0D98DC2/WinACPI_OSI.docx
        Name(WINV, Package()
        {
            "Windows",              // generic Windows query
            "Windows 2001",         // Windows XP
            "Windows 2001 SP2",     // Windows XP SP2
            //"Windows 2001.1",     // Windows Server 2003
            //"Windows 2001.1 SP1", // Windows Server 2003 SP1
            "Windows 2006",         // Windows Vista
            "Windows 2006 SP1",     // Windows Vista SP1
            //"Windows 2006.1",     // Windows Server 2008
            "Windows 2009",         // Windows 7/Windows Server 2008 R2
            //"Windows 2012",       // Windows 8/Windows Sesrver 2012
            //"Windows 2013",       // Windows 8.1/Windows Server 2012 R2
            //"Windows 2015",       // Windows 10/Windows Server TP
        })
        Return (LNotEqual(Match(WINV, MEQ, Arg0, MTR, 0, 0), Ones))
    }

    Scope(\_SB.PCI0)
    {
        // inject properties for onboard audio
        Method(HDEF._DSM, 4)
        {
            If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "layout-id", Buffer() { 1, 0, 0, 0, },
                "PinConfigurations", Buffer(Zero) {},
            })
        }
        
        // Disable B0D3 and rename B0D3 to HDAU
        Device(HDAU)
        {
            Name(_ADR, 0x00030000)
            // by storing zero to B0D3._ADR, we keep B0D3 from attaching to the device
            Method(_INI) { Store(0, \_SB.PCI0.B0D3._ADR) }
            // injecting properties for HDMI audio
            Method(_DSM, 4)
            {
                If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
                Return (Package()
                {
                    "layout-id", Buffer() { 1, 0, 0, 0, },
                    "hda-gfx", Buffer() { "onboard-1" },
                })
            }
        }
        
        // By defining GFX0._STA as zero, we keep GFX0 from attaching to the device
        // Note: this only works becuase GFX0._STA is not defined in OEM ACPI files.
        Name(GFX0._STA, 0)
        
        // Define new IGPU, in replacement of GFX0
        Device(IGPU)
        {
            Name(_ADR, 0x00020000)
            // by storing zero to GFX0._ADR, we keep GFX0 from attaching to the device
            Method(_INI) { Store(0, \_SB.PCI0.GFX0._ADR) }
            // injecting properties for HDMI audo
            Method(_DSM, 4)
            {
                If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
                Return (Package()
                {
                    "hda-gfx", Buffer() { "onboard-1" },
                })
            }
        }
        
        // Inject properties for USB: EHC1/EHC2/XHC
        Method(EH01._DSM, 4)
        {
            If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                "AAPL,current-available", 2100,
                "AAPL,current-extra", 2200,
                "AAPL,current-extra-in-sleep", 1600,
                //"AAPL,device-internal", 0x02,
                "AAPL,max-port-current-in-sleep", 2100,
            })
        }
        Method(EH02._DSM, 4)
        {
            If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                "AAPL,current-available", 2100,
                "AAPL,current-extra", 2200,
                "AAPL,current-extra-in-sleep", 1600,
                //"AAPL,device-internal", 0x02,
                "AAPL,max-port-current-in-sleep", 2100,
            })
        }
        Method(XHC._DSM, 4)
        {
            If (LEqual(Arg2, Zero)) { Return (Buffer() { 0x03 } ) }
            Return (Package()
            {
                "subsystem-id", Buffer() { 0x70, 0x72, 0x00, 0x00 },
                "subsystem-vendor-id", Buffer() { 0x86, 0x80, 0x00, 0x00 },
                "AAPL,current-available", 2100,
                "AAPL,current-extra", 2200,
                "AAPL,current-extra-in-sleep", 1600,
                //"AAPL,device-internal", 0x02,
                "AAPL,max-port-current-in-sleep", 2100,
            })
        }
    }
}

