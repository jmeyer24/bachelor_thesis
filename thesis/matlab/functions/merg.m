% see 'merging.mlx'
% takes nodes and edges files and merges stacked nodes to one
function [nodes,edges,n] = merg(pathData)
    addpath("CircStat2012a")

    [nodes,edges] = readBoth(pathData);
    
    all_nodes = nodes;

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
    
    % all representatives get circ_mean bearing
    % first all but last, then last too
    for i = 1:n-1
        nodes(i,4) = circ_mean(all_nodes(IA(i):IA(i+1)-1,4));
    end
    nodes(end,4) = circ_mean(all_nodes(IA(n):end,4));

    clearvars -except nodes edges n
end

