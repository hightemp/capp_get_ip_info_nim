import os
import json
import sequtils
import strutils
import sugar
import posix
import strformat
import math

import lib

# 89.107.0.0 - 1500184576

var sBasePath = "./data/datacenter-list/"
var aFiles = toSeq(walkDir(sBasePath, relative=true))

var oDatabase: seq[seq[string]] = @[]
var sName = ""

for oFilePath in aFiles:
    case oFilePath.kind:
        of pcFile:
            echo "[!] File: ", oFilePath.path
            let sData = readFile(sBasePath & oFilePath.path)
            let oJSONData = parseJson(sData)

            for iK, oV in oJSONData.toSeq:
                var sRow = oV.getStr()
                if sRow.contains("anonymous"):
                    continue
                if iK == 0:
                    var aName = sRow.split("\t")
                    echo aName[1]
                    sName = aName[1]
                if iK == oJSONData.len:
                    echo ""
                if iK >= 6:
                    var aRecord: seq[string] = @[]
                    aRecord.add("P")
                    aRecord.add(sName)
                    aRecord = concat(aRecord, sRow.split("\t"))
                    aRecord[2] = aRecord[2].replace("xxx", "0")
                    aRecord[3] = aRecord[3].replace("xxx", "255")
                    aRecord[2] = $(fnIPToInt32(aRecord[2]))
                    aRecord[3] = $(fnIPToInt32(aRecord[3]))
                    oDatabase.add(aRecord)
        of pcDir:
            echo "[!] Dir: ", oFilePath.path
        of pcLinkToFile:
            echo "[!] Link to file: ", oFilePath.path
        of pcLinkToDir:
            echo "[!] Link to dir: ", oFilePath.path
        else:
            echo ""

sBasePath = "./data/lite.ip2location.com/"
aFiles = toSeq(walkDir(sBasePath, relative=true))

for oFilePath in aFiles:
    case oFilePath.kind:
        of pcFile:
            echo "[!] File: ", oFilePath.path
            let sData = readFile(sBasePath & oFilePath.path)
            let oJSONData = parseJson(sData)

            for iK, oV in oJSONData.toSeq:
                if oV.kind == JString:
                    continue
                var aRow = oV.getElems()
                if aRow.len<2:
                    continue
                var sCountry = oFilePath.path.replace("-ip-address-ranges.json", "")
                var aRecord: seq[string] = @[]
                aRecord.add("C")
                aRecord.add(sCountry)
                aRecord.add($(fnIPToInt32(aRow[0].getStr())))
                aRecord.add($(fnIPToInt32(aRow[1].getStr())))
                oDatabase.add(aRecord)
        of pcDir:
            echo "[!] Dir: ", oFilePath.path
        of pcLinkToFile:
            echo "[!] Link to file: ", oFilePath.path
        of pcLinkToDir:
            echo "[!] Link to dir: ", oFilePath.path
        else:
            echo ""

writeFile("./bundle/packed_data.json", $(%*(oDatabase)))