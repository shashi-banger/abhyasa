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
	lastDir byte
	// Count of each direction in pSteps
	dirCount   [6]byte
	lastOrient Orientation
}

func NewPos(pos *Pos, orientNext Orientation) *Pos {
	var nextDir byte
	npos := Pos{}
	npos.dirCount = pos.dirCount
	lastDir := pos.lastDir
	if pos.lastOrient == orientNext {
		if orientNext == ANTICLOCKWISE {
			nextDir = acNext[lastDir]
		} else {
			nextDir = acNext[lastDir]
		}
		npos.lastOrient = orientNext
		npos.lastDir = nextDir
		npos.dirCount[nextDir] += 1
		if npos.dirCount[nextDir] > maxStespInADirection {
			return nil
		}

	} else {
		npos.lastOrient = orientNext
		npos.lastDir = lastDir
		npos.dirCount[lastDir] += 1
		if npos.dirCount[lastDir] > maxStespInADirection {
			return nil
		}
	}
	return &npos
}

func main() {
	finalCount := 0
	totalSteps = 15
	maxStespInADirection = byte(totalSteps / 5)

	curPos := []*Pos{}
	pos1 := Pos{}
	pos1.lastDir = 1
	pos1.dirCount[1] = 1
	pos1.lastOrient = ANTICLOCKWISE
	curPos = append(curPos, &pos1)

	pos2 := Pos{}
	pos2.lastDir = 5
	pos2.dirCount[5] = 1
	pos2.lastOrient = CLOCKWISE
	curPos = append(curPos, &pos2)

	fmt.Println(len(curPos))
	curSteps := 1
	for len(curPos) > 0 {
		newPos := []*Pos{}
		curSteps += 1
		for _, p := range curPos {
			p1 := NewPos(p, ANTICLOCKWISE)
			if p1 != nil {
				if curSteps == totalSteps {
					finalCount += 1
				} else {
					newPos = append(newPos, p1)
				}
			}
			p2 := NewPos(p, CLOCKWISE)
			if p2 != nil {
				if curSteps == totalSteps {
					finalCount += 1
				} else {
					newPos = append(newPos, p2)
				}
			}
		}
		curPos = newPos
	}
	fmt.Println("Final Count", finalCount)

}
