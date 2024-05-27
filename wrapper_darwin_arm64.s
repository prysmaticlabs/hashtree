// +build darwin,arm64

TEXT ·HashtreeHash(SB), 0, $2048-24
		    MOVQ output+0(FP), X0
		    MOVQ input+8(FP), X1
		    MOVQ count+16(FP), X2


		    CMPB ·hasShani(SB), $1
		    LE shani
		    CALL _hashtree_sha256_neon_x4
		    RET

shani:
		    CALL _hashtree_sha256_sha_x1
		    RET
