import strutils

converter toUInt32*(x: int): uint32 = cast[uint32](x)

func fnIPToInt32*(sIP: string): uint32 =
    var aIP = sIP.split(".")
    if (aIP[0].len>3):
        return 0
    var iI1 = aIP[0].parseInt()
    var iI2 = aIP[1].parseInt()
    var iI3 = aIP[2].parseInt()
    var iI4 = aIP[3].parseInt()
    return iI1 shl (8*3) or iI2 shl (8*2) or iI3 shl (8*1) or iI4.toUInt32()

func fnIPToInt*(sIP: string): int =
    var aIP = sIP.split(".")
    if (aIP[0].len>3):
        return 0
    var iI1 = aIP[0].parseInt()
    var iI2 = aIP[1].parseInt()
    var iI3 = aIP[2].parseInt()
    var iI4 = aIP[3].parseInt()
    return iI1 shl (8*3) or iI2 shl (8*2) or iI3 shl (8*1) or iI4