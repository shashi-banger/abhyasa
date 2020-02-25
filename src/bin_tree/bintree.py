from __future__ import annotations
from dataclasses import dataclass

@dataclass
class Node:
    value: object
    left: Node
    right: Node

class BinTree:
    def __init__(self):
        self.tree = None 
        self.compare = None

    def _insert(self, subtree, v):
        if self.compare(subtree.value,v) > 0:
            if subtree.left is None:
                subtree.left = Node(v, None, None)
            else:
                self._insert(subtree.left, v)
        else:
            if subtree.right is None:
                subtree.right = Node(v,None,None)
            else:
                self._insert(subtree.right, v)
        return

    def insert(self, v):
        if self.tree is None:
            self.tree = Node(v, None, None)
        else:
            self._insert(self.tree, v)
        return


    def create(self, list_objs, compare):
        self.compare = compare
        for v in list_objs:
            self.insert(v)

    def __repr__(self):
        return str(self.tree)

if __name__ == "__main__":
    import unittest
    class BinTreeTest(unittest.TestCase):
        def test_01_create_bintree(self):
            bt = BinTree()
            bt.create([6,2,8, 4,5,6], lambda a, b: 1 if a > b else 0)
            print(repr(bt))

    unittest.main()

