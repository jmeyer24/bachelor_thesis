topic
paper tristan
slam-pathfinding
graph orientation with angles
mds algorithms
current objective function
visualization of thy
analytical g(f) in range of [0,1]
application of mds algorithms 

tristan baumann navigationsmodell -> graphenbasierte raumrepräsentation
-> hat schätzungen von globaler referenzrichtung -> interne referenzrichtung
also:
interne auf tatsächliche globale referenzrichtung ausrichten durch rotation
-> metrisches embedding finden durch
MDS, multidimensional scaling:
durch daten (z.b. distanzen zwischen punkten) graphen aufbauen...

classic mds:
"Given a distance matrix with the distances between each pair of objects in a set [...] {, and a chosen number of dimensions, N,} an MDS algorithm places each object into [this] {N-dimensional} space such that the between-object distances are preserved as well as possible. [...] {For N=1, 2, and 3, the resulting points can be visualized on a scatter plot.[2]}"
"Given a distance matrix with the distances between each pair of objects in a set [...] an MDS algorithm places each object into [this][...] space such that the between-object distances are preserved as well as possible."

"A valid dissimilarity matrix must satisfy both of the following constraints: (i)
self-similarity (dii = 0) and (ii) symmetry (dij = dji)."

SLAM - simultaneous localization and mapping
problem of mobile robot, which should localize itself on an on the fly self-generated
map, while keeping the mapping consistent
current state of the art: solved but optimizable
-> error in orientation 
"SLAM is a process by which a mobile
robot can build a map of an environment
and at the same time use this map
to deduce its location."

"agent is maintaining an allocentric reference direction"

6. Compass direction drift over a large explored area. The  estimate
may deviate substantially
