setwd('D:/Documents/Studium/Kogni_Tuebingen/Bachelorarbeit/tristan_graph_data')

library(igraph)

dat_vertices <- read.table('graph_vertices.vim',header=TRUE)
dat_edges <- read.table('graph_edges.vim',header=TRUE)
#dat <- read.graph('graph.vim')

small_graph <- graph_from_data_frame(head(dat_edges[1:2]))
medium_graph <- graph_from_data_frame(head(dat_edges[1:2],50))
medium_graph <- graph_from_data_frame(head(dat_edges[1:2],100))
#medium_graph <- graph_from_data_frame(head(dat_edges[1:2],1000))
graph <- graph_from_data_frame(dat_edges[1:2])
#test <- graph_from_data_frame(dat_edges[1:2],vertices=dat_vertices[2:3])
plot(medium_graph)
#plot(graph)
#plot(dat_vertices[2:3],type='o',pch=20)
