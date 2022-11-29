#!/bin/bash

nim c pack_jsons_to_one.nim

if [ "$?" != "0" ]; then
    echo "====================================================="
    echo "ERROR"
    echo
    exit 1
fi

./pack_jsons_to_one

nimassets -d=bundle -o=assetsfile.nim

if [ "$?" != "0" ]; then
    echo "====================================================="
    echo "ERROR"
    echo
    exit 1
fi

nim c capp_get_ip_info_nim.nim

if [ "$?" != "0" ]; then
    echo "====================================================="
    echo "ERROR"
    echo
    exit 1
fi
