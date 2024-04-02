# hashtree nim bindings
# Copyright (c) 2024 Status Research & Development GmbH
# Licensed and distributed under
#   * MIT license (license terms in the root directory or at https://opensource.org/licenses/MIT).
# This file may not be copied, modified, or distributed except according to those terms.

{.pragma: hashtreedecl, importc, cdecl, gcsafe, raises: [].}

import std/[os, strutils]

const srcDir = currentSourcePath.parentDir.replace('\\', '/') & "/src/"

{.compile: srcDir & "hashtree.c".}

# The assembly syntax used doesn't work on other platforms for the time being
when defined(linux):
  when defined(arm64):
    {.compile: srcDir & "sha256_armv8_neon_x1.S".}
    {.compile: srcDir & "sha256_armv8_neon_x4.S".}

  elif defined(amd64):
    {.compile: srcDir & "sha256_avx_x1.S".}
    {.compile: srcDir & "sha256_avx_x4.S".}
    {.compile: srcDir & "sha256_avx_x8.S".}
    {.compile: srcDir & "sha256_avx_x16.S".}
    {.compile: srcDir & "sha256_shani.S".}
    {.compile: srcDir & "sha256_sse_x1.S".}

type HashFcn* = proc(output: pointer, input: pointer, count: uint64) {.
  cdecl, noSideEffect, gcsafe, raises: [].}

proc hashtree_init*(override: HashFcn): cint {.hashtreedecl.}
func hashtree_hash*(output: pointer, input: pointer, count: uint64) {.
  hashtreedecl.}
