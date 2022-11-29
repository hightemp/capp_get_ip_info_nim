echo "TEST 1"

./capp_get_ip_info_nim 119.252.74.21

if [ "$()" == '[["P","Colocity Pty Ltd"],["C","australia"]]' ]; then
    echo "OK"
else
    echo "FAIL"
fi