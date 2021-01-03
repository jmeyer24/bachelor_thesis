% see 'merging.mlx'
% takes nodes and edges files and merges stacked nodes to one
function [nodes,edges,n] = merg(pathNodes,pathEdges)
    nodes = read(pathNodes);
    edges = read(pathEdges);
    nodes(1,:) = [];
    edges = edges(:,[3 1 2 4 5]);
    [~,IA,~] = unique(nodes(:,[2 3]),'rows','stable');
    nodes = nodes(IA,:);  % these nodes are the representatives
    n = size(nodes,1);
    maf = edges(:,2)' < IA;
    mat = edges(:,3)' < IA;
    for i = 1:size(edges,1)
        [~,ia,~] = unique(maf(:,i),'last');
        ia(1);
        edges(i,2) = IA(ia(1));

        [~,ia,~] = unique(mat(:,i),'last');
        edges(i,3) = IA(ia(1));
    end
    selfloops = edges(:,2)==edges(:,3);
    edges(selfloops,:) = [];
    mapping = [(1:length(IA))' IA];
    nodes(:,1) = 1:size(nodes,1);
    edges(:,1) = 1:size(edges,1);
    for i = 1:size(edges,1)
        idx = find(edges(i,2)==mapping(:,2));
        edges(i,2) = idx;

        idx = find(edges(i,3)==mapping(:,2));
        edges(i,3) = idx;
    end
    clearvars -except nodes edges n
    save materials\last_merg.mat
end

