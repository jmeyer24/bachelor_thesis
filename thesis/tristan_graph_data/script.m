cd D:/Documents/Studium/Kogni_Tuebingen/Bachelorarbeit/thesis/tristan_graph_data
clear
clc
format shortG
addpath("matlab scripts")

%f = fopen("graph_small.lgf");
nodes = read("small_graph_vertices.txt");
edges = read("small_graph_edges.txt");
edges = edges(:,[3 1 2 4 5]);
top(nodes)
top(edges)

normalized = true;
n = size(nodes,1);

% build M
m = eye(n-1);
minuses = repelem(-1,n-1);

m = [minuses' m];
%m = m(:,[n,1:n-1]);
M = zeros(n*(n-1),n-1);
% this would be a 19.2GB matrix XD... what to do?
% this isnt even the final form of the matrix

for i = 1:(n-1)
    m([i i+1],:) = m([i+1 i],:);
    i
    %M = [M;m];
end

%colnames(M) = node_names;
%M = as.matrix(M); %this is important, else it is fucked up...

% build X
%X = cbind(nodes.xPos[1:n],nodes.yPos[1:n]);
%rownames(X) = node_names;
%colnames(X) = c('x','y');

% build P
%P = M * X';
%print(head(P,n))

%solve() quite faster than ginv()
%mm = t(M) %*% M
%if(is.singular.matrix(mm)){X_new = ginv(mm) %*% t(M) %*% P}
%print(X_new)

% constructing functions
%NormalizeVector = function(x) {x / sqrt(sum(x^2))};

% CalculateObjectiveFunction = function(pm){
%   sum = 0
%   
%   for(rowname in rownames(arcs)){
%     c_arc = arcs[rowname,]
%     from_pos = pm[paste0("x",c_arc.from),]
%     to_pos = pm[paste0("x",c_arc.to),]
%     c_unitvec = matrix(c(cos(c_arc.angle),sin(c_arc.angle)),1)
%     
%     vec_ij = to_pos - from_pos - c_unitvec
%     if(normalized){
%       NormalizeVector(vec_ij)
%     }
%     sum = sum + sum(vec_ij^2)
%     
%     print(c_arc)
%     print(from_pos)
%     print(to_pos)
%     print(c_unitvec)
%   }
%   
%   sum
% }
