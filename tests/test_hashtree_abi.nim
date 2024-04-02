# hashtree nim bindings
# Copyright (c) 2024 Status Research & Development GmbH
# Licensed and distributed under
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
# This file may not be copied, modified, or distributed except according to those terms.

import ../hashtree_abi

func test() {.raises: [].} =
  var data: array[64, byte]
  hashtree_hash(addr data[0], addr data[0], 1)

  doAssert data[0] == 245
when isMainModule:
  test()
