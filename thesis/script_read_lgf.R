setwd("D:/Documents/Studium/Kogni_Tuebingen/Bachelorarbeit/thesis/tristan_graph_data")
rm(list=ls())
require(MASS)
library(data.table)
library(dplyr)

d <- read.delim("graph_small.lgf",header=TRUE,skip=1,sep="\t")
#dat <- read.csv("small_graph_edges.csv",sep="\t")

normalized <- FALSE #"no"
at_index <- as.numeric(rownames(d[d$label == "@arcs",]))
arc_names <- c("from","to","label","distance","angle")

#nodes 
nodes <- d[1:(at_index-1),]
n <- length(nodes$label)
nodes$yPos <- as.numeric(nodes$yPos)

#arcs
arcs <- d[(at_index+2):dim(d)[1],]
names(arcs) <- arc_names
arcs <- arcs[,c(3,1,2,4,5)]
arcs$from <- as.numeric(arcs$from)
arcs$angle <- as.numeric(arcs$angle)

# build M
node_names <- paste0('x',1:n)
m <- as.data.frame(diag(n-1))
m$V0 <- -1
m <- m[,c(n,1:n-1)]
rownames(m) <- paste0('x',1,'_',2:n)

M <- m
for(i in 1:(n-1)){
  m[c(i,i+1)] <- m[c(i+1,i)]
  #rownames(m) <- paste0('x',i+1,'_',(1:n)[-(i+1)])
  M <- bind_rows(M,m) #this takes sooooooooooooooooooooooooooooooooo long...
  print(i)
}
colnames(M) <- node_names
M <- as.matrix(M) #this is important, else it is fucked up...

# build X
X <- cbind(nodes$xPos[1:n],nodes$yPos[1:n])
rownames(X) <- node_names
colnames(X) <- c('x','y')

# build P
P <- M %*% X
print(head(P,n))

#solve() quite faster than ginv()
#mm <- t(M) %*% M
#if(is.singular.matrix(mm)){X_new <- ginv(mm) %*% t(M) %*% P}
#print(X_new)

# constructing functions
NormalizeVector <- function(x) {x / sqrt(sum(x^2))}

# CalculateObjectiveFunction <- function(pm){
#   sum <- 0
#   
#   for(rowname in rownames(arcs)){
#     c_arc <- arcs[rowname,]
#     from_pos <- pm[paste0("x",c_arc$from),]
#     to_pos <- pm[paste0("x",c_arc$to),]
#     c_unitvec <- matrix(c(cos(c_arc$angle),sin(c_arc$angle)),1)
#     
#     vec_ij <- to_pos - from_pos - c_unitvec
#     if(normalized){
#       NormalizeVector(vec_ij)
#     }
#     sum <- sum + sum(vec_ij^2)
#     
#     print(c_arc)
#     print(from_pos)
#     print(to_pos)
#     print(c_unitvec)
#   }
#   
#   sum
# }