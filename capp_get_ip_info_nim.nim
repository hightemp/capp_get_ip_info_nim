import json
import std/parseopt
import sequtils
import strutils

import lib

proc writeHelp() = 
    echo ""
    echo "capp_get_ip_info_nim 192.168.1.1"
    echo ""
    system.quit(1)

proc writeVersion() = 
    echo "v0.1"
    system.quit(2)

var filename: string
let params: seq[string] = @[]

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

var sDataFile = "packed_data.json"

let sData = readFile(sDataFile)
let oJSONData = parseJson(sData)

var iIP = fnIPToInt32(sIP)

var aList = oJSONData.toSeq()
var aResult: seq[seq[string]] = @[]

for iK, oV in aList:
    var aRow = oV.toSeq()
    var iFrom = aRow[2].getStr().parseInt()
    var iTo = aRow[3].getStr().parseInt()

    if iFrom<=iIP and iIP<=iTo:
        aResult.add(@[aRow[0].getStr(), aRow[1].getStr()])

echo $(%*(aResult))
