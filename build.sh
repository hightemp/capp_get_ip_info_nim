#!/bin/bash

nim c pack_jsons_to_one.nim
./pack_jsons_to_one

nimassets -d=bundle -o=assetsfile.nim
nim c capp_get_ip_info_nim.nim
