
import networkx as nx


g = nx.DiGraph()


# words = ["a","b","c","d","e","f"]
# g.add_nodes_from(words[i] for i in range(0, len(words)))
# g.add_edge("a","b")
# g.add_edge("a","c")
# g.add_edge("a","d")
# g.add_edge("a","e")


#qs = [[1,2,3,4], [1,2,31,4], [1,2,33,4], [11,2,3,4], [1,5,3,4]]
qs = [(0,0,0),(1,23,134),(2,23,3),(3,23,3),(4,23,3),(5,23,3)]

g.add_nodes_from(qs[i] for i in range(0, len(qs)))



g.add_weighted_edges_from([ (qs[0],qs[1],3.0), (qs[0],qs[2],1.5), (qs[0],qs[3],7.5), (qs[2],qs[4],.25) , (qs[1],qs[4],.25) ])

g.add_edge(qs[0],qs[1])
g.add_edge(qs[0],qs[2])
g.add_edge(qs[2],qs[3])
g.add_edge(qs[1],qs[2])




print "nodes: ",g.nodes
print "neighbors:", [n for n in g.neighbors(qs[0])]

start_node_id = qs[0]
end_node_id = qs[4]

try:
	path = nx.dijkstra_path(g, source=start_node_id,target=end_node_id, weight="weight")
	print "path:",path
except nx.exception.NetworkXNoPath:
	print "\nError: No Path Found"
    


# children: [n for n in g.neighbors(<node id>)]
