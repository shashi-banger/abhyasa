package main

import "fmt"

// Direction 1,2,3,4,5 are the directions taken in anti-clockwise direction

type Orientation byte

const (
	ANTICLOCKWISE Orientation = iota
	CLOCKWISE
)

var (
	acNext               = map[byte]byte{1: 2, 2: 3, 3: 4, 4: 5, 5: 1}
	cNext                = map[byte]byte{1: 5, 2: 1, 3: 2, 4: 3, 5: 4}
	maxStespInADirection byte
	totalSteps           int
)

type Pos struct {
	lastDir    byte
	lastOrient Orientation
	nPaths     int64
}

func NewPos(nk *[6]byte, pos *Pos, orientNext Orientation) *Pos {
	var nextDir byte
	npos := Pos{}
	lastDir := pos.lastDir
	npos.nPaths = pos.nPaths
	if pos.lastOrient == orientNext {
		if orientNext == ANTICLOCKWISE {
			nextDir = acNext[lastDir]
		} else {
			nextDir = cNext[lastDir]
		}
		npos.lastOrient = orientNext
		npos.lastDir = nextDir
		nk[nextDir] += 1
		if nk[nextDir] > maxStespInADirection {
			return nil
		}

	} else {
		npos.lastOrient = orientNext
		npos.lastDir = lastDir
		nk[lastDir] += 1
		if nk[lastDir] > maxStespInADirection {
			return nil
		}
	}
	return &npos
}

func main() {
	var finalCount int64 = 0
	totalSteps = 70
	maxStespInADirection = byte(totalSteps / 5)

	// The key in curPos is the count of various directions taken in N steps. Sum of count of each direction will N.
	curPos := map[[6]byte]*Pos{}
	pos1 := Pos{}
	pos1.lastDir = 1
	pState := [6]byte{}
	pState[1] = 1
	pos1.lastOrient = ANTICLOCKWISE
	pos1.nPaths = 1
	curPos[pState] = &pos1

	pos2 := Pos{}
	pos2.lastDir = 5
	pState2 := [6]byte{}
	pState2[5] = 1
	pos2.lastOrient = CLOCKWISE
	pos2.nPaths = 1
	curPos[pState2] = &pos2

	fmt.Println(len(curPos))
	curSteps := 1
	for curSteps < totalSteps {
		newPos := map[[6]byte]*Pos{}
		curSteps += 1
		for k, p := range curPos {
			nk := k
			p1 := NewPos(&nk, p, ANTICLOCKWISE)
			if p1 != nil {
				if _, ok := newPos[nk]; ok {
					newPos[nk].nPaths += p1.nPaths
				} else {
					newPos[nk] = p1
				}
			}
			nk1 := k
			p2 := NewPos(&nk1, p, CLOCKWISE)
			if p2 != nil {
				if _, ok := newPos[nk1]; ok {
					newPos[nk1].nPaths += p2.nPaths
				} else {
					newPos[nk1] = p2
				}
			}
		}
		if curSteps == totalSteps {
			finalCount = newPos[[6]byte{0, maxStespInADirection, maxStespInADirection, maxStespInADirection, maxStespInADirection, maxStespInADirection}].nPaths
		}
		//fmt.Println("Cursteps", curSteps)
		curPos = newPos
	}
	fmt.Println("Final Count", finalCount)

}
