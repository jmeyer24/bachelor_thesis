setwd('D:/Documents/Studium/Kogni_Tuebingen/Bachelorarbeit/repository/thesis')

library(igraph)

dat_nodes <- read.table('tristan_graph_data/small_graph_nodes.txt',header=TRUE)
dat_edges <- read.table('tristan_graph_data/small_graph_edges.txt',header=TRUE)
# dat <- read.graph('graph.vim')

small_graph <- graph_from_data_frame(head(dat_edges))
medium_graph <- graph_from_data_frame(head(dat_edges[1:2],50))
medium_graph <- graph_from_data_frame(head(dat_edges[1:2],100))
# medium_graph <- graph_from_data_frame(head(dat_edges[1:2],1000))
graph <- graph_from_data_frame(dat_edges[1:2])
# test <- graph_from_data_frame(dat_edges[1:2],vertices=dat_vertices[2:3])
plot(medium_graph)
# plot(graph)
# plot(dat_nodes[2:3],type='o',pch=20)
