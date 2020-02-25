from networkx import nx

#class Dijkstart:
#    pass





if __name__ == "__main__":
    import unittest
    import random
    class DijkstraTest(unittest.TestCase):
        def test_01(self):
            G = nx.gnm_random_graph(10, 22)
            edge_weights = {v: dict(weight=random.randint(4, 20)) for v in G.edges}
            nx.set_edge_attributes(G, edge_weights)
            d_path = nx.dijkstra_path(G, 0, 3, weight='weight')
            print(d_path)
            print(G.edges.data())

unittest.main()