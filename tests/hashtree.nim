import ../hashtree_abi

var data: array[64, byte]
hashtree_hash(addr data[0], addr data[0], 1)

doAssert data[0] == 245
