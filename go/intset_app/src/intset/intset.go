package intset

import (
	"fmt"
)
type IntSet struct {
	words  []uint64
}

func (s *IntSet) Add(val int) {
	word, bit := val/64, uint(val % 64)
	for i := len(s.words); i <= word; i++ {
		s.words = append(s.words, 0)
	}
	s.words[word] = s.words[word] | (1 << bit)
}

func (s *IntSet) Has(val int) bool {
	word, bit := val/64, uint(val % 64)
	return (len(s.words) > word) && (s.words[word] & (1 << bit) != 0)
}

func (s *IntSet) String() string {
	ret_str := "{"
	for i := 0; i < len(s.words); i++ {
		for j := 0; j < 64; j++ {
			if s.words[i] & (1 << uint(j)) != 0 {
				ret_str += fmt.Sprintf("%d, ", i*64 + j)
			}
		}
	}
	ret_str += "}"
	return ret_str
}

