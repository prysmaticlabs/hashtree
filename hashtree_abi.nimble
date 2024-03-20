mode = ScriptMode.Verbose

packageName   = "hashtree_abi"
version       = "0.1.0"
author        = "Prysmatic labs, Status Research and Development GmbH"
description   = "Low-level ABI package for hashtree, a SHA256 implementation specialized for merkle trees and 64-byte chunks"
license       = "MIT"
installDirs   = @["src"]
installFiles  = @["hashtree_abi.nim"]

requires "nim >= 1.6.0"
