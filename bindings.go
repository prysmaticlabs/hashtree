package hashtree

import "fmt"

//go:noescape
func HashtreeHash(output *byte, input *byte, count uint64)

func Hash(digests [][32]byte, chunks [][32]byte) error {
	if len(chunks) == 0 {
		return nil
	}

	if len(chunks)%2 == 1 {
		return fmt.Errorf("odd number of chunks")
	}
	if len(digests) < len(chunks)/2 {
		return fmt.Errorf("not enough digest length, need at least %v, got %v", len(chunks)/2, len(digests))
	}
	if supportedCPU {
		HashtreeHash(&digests[0][0], &chunks[0][0], uint64(len(chunks)/2))
	} else {
		sha256_1_generic(digests, chunks)
	}
	return nil
}
