import json
import std/parseopt
import sequtils
import strutils
import math
import lib

proc writeHelp() = 
    echo ""
    echo "./capp_get_ip_info_nim 192.168.1.1"
    echo ""
    system.quit(1)

proc writeVersion() = 
    echo "v0.1"
    system.quit(2)

var params: seq[string] = @[]

var sIP = ""

for kind, key, val in getopt(params):
    case kind
    of cmdArgument:
        sIP = key
    of cmdLongOption, cmdShortOption:
        case key
        of "help", "h": writeHelp()
        of "version", "v": writeVersion()
    of cmdEnd: assert(false) # cannot happen
if sIP == "":
    writeHelp()

import assetsfile

var sOrgData = assetsfile.getAsset("bundle/org_data.json")
var sCountriesData = assetsfile.getAsset("bundle/countries_data.json")

# var sDataFile = "packed_data.json"
# var sData = readFile(sDataFile)

proc map(num: int, inMin: int, inMax: int, outMin: int, outMax: int): int =
    return math.ceil((num - inMin) * (outMax - outMin) / (inMax - inMin)).toInt() + outMin;

var oOrgJSONData = parseJson(sOrgData)
var oCountriesJSONData = parseJson(sCountriesData)

var aResult: seq[seq[string]] = @[]

for oJSONData in @[oOrgJSONData, oCountriesJSONData]:
    var iIP = fnIPToInt(sIP)

    var aList = oJSONData.toSeq()
    var iLen = aList.len()

    var iPos = math.ceil(iLen/2).toInt()
    var iDelta = math.ceil(iLen/2).toInt()
    var oItem = aList[iPos].toSeq()[2]
    var iPosIP = oItem.getStr().parseInt()

    oItem = aList[0].toSeq()[2]
    var iFirstIP = oItem.getStr().parseInt()
    oItem = aList[iLen-1].toSeq()[2]
    var iLastIP = oItem.getStr().parseInt()

    var iCalcPos = map(iIP, iFirstIP, iLastIP, 0, iLen-1)
    iPosIP = iIP

    # echo iLen, " ", sIP, " ", iIP, " ", iCalcPos

    while abs(iDelta)>1:
        if iIP>iPosIP:
            iDelta = math.ceil(iDelta/2).toInt()
            iPos = iPos + iDelta
        elif iIP<iPosIP:
            iDelta = math.ceil(iDelta/2).toInt()
            iPos = iPos - iDelta
        oItem = aList[iPos].toSeq()[2]
        iPosIP = oItem.getStr().parseInt()
        # echo iDelta, " ", iPos, " ", iPosIP, " ", $(%*(aList[iPos].toSeq()))


    # for iK, oV in aList:
    #     var aRow = oV.toSeq()
    #     var iFrom = aRow[2].getStr().parseInt()
    #     var iTo = aRow[3].getStr().parseInt()

    #     if iFrom<=iIP and iIP<=iTo:
    #         aResult.add(@[aRow[0].getStr(), aRow[1].getStr()])

    if (aList[iPos][2].getStr().parseInt()<=iIP and iIP<=aList[iPos][3].getStr().parseInt()):
        aResult.add(@[aList[iPos][0].getStr(), aList[iPos][1].getStr()])
        
echo $(%*(aResult))
