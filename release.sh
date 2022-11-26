nim c \
    --passL:-static \
    --spellSuggest \
    -d:release --opt:size \
    capp_get_ip_info_nim.nim

if [ "$?" != "0" ]; then
    echo "====================================================="
    echo "ERROR"
    echo
    exit 1
fi

strip -s ./capp_get_ip_info_nim

if [ "$?" != "0" ]; then
    echo "====================================================="
    echo "ERROR"
    echo
    exit 1
fi

upx --best ./capp_get_ip_info_nim

if [ "$?" != "0" ]; then
    echo "====================================================="
    echo "ERROR"
    echo
    exit 1
fi

git add .
git commit -am "`date` update"
git push

if [ "$?" != "0" ]; then
    echo "====================================================="
    echo "ERROR"
    echo
    exit 1
fi

timestamp=$(date +%s)
VERSION=$(echo `cat VERSION`.$timestamp)

gh release create $VERSION -t $VERSION -n "" capp_get_ip_info_nim