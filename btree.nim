import abathur/btree
import abathur/pager

var mgr: PageMgr
initPageMgr(addr mgr, 1, ".")
let desc = TypeDesc(kind: tyInt32, size: 4)
let x = pinFreshNode(addr mgr)

var st = newBTree(x.id, desc, desc, cmpInt32, addr mgr)
st.put("100", "a")
st.put("10", "b")
st.put("200", "c")
st.put("30", "d")
st.put("5", "e")
st.put("1000", "g")

echo st.get("100")
echo st.get("6")