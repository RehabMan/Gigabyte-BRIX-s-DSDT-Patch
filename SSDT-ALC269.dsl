// generated from: ../codec.git/gen_ahhcd.sh ALC269
//DefinitionBlock("", "SSDT", 2, "hack", "_ALC269", 0)
//{
    External(_SB.PCI0.HDEF, DeviceObj)
    Name(_SB.PCI0.HDEF.RMCF, Package()
    {
        "CodecCommander", Package()
        {
            "Disable", ">y",
        },
        "CodecCommanderPowerHook", Package()
        {
            "Disable", ">y",
        },
        "CodecCommanderProbeInit", Package()
        {
            "Version", 0x020600,
            "10ec_0269", Package()
            {
                "PinConfigDefault", Package()
                {
                    Package(){},
                    Package()
                    {
                        "LayoutID", 2,
                        "PinConfigs", Package()
                        {
                            Package(){},
                            0x14, 0x400000f0,
                            0x15, 0x02214070,
                            0x16, 0x400000f0,
                            0x17, 0x400000f0,
                            0x18, 0x400000f0,
                            0x19, 0x400000f0,
                            0x1a, 0x400000f0,
                            0x1b, 0x400000f0,
                            0x1e, 0x014b6190,
                        },
                    },
                },
            },
        },
    })
//}
//EOF
