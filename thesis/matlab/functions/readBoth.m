% takes a given file path and forms its content to a matrix
function [nodes,edges] = readBoth(pathData)
    nodesFile = fopen(append('data\'+pathData+'\nodes.txt'));
    edgesFile = fopen(append('data\'+pathData+'\edges.txt'));
    
    nodes = textscan(nodesFile, '%f%f%f%f%f', 'HeaderLines',1);
    edges = textscan(edgesFile, '%f%f%f%f%f', 'HeaderLines',1);
    
    fclose(nodesFile);
    fclose(edgesFile);
    
    nodes = cell2mat(nodes);
    edges = cell2mat(edges);
    
    nodes(1,:) = [];
    edges = edges(:,[3 1 2 4 5]);
end