%BUILD builds matrices and calculates embedding of a given dataset
function [nodes,edges,n,emb,M,P,Sin,Cos] = build(pathData)
    [nodes,edges,n,timeMerg] = merg(pathData);

    [M,timeM] = buildM(n);
    
    Cos = sparse(edges(:,2),edges(:,3),cos(edges(:,5)),n,n);
    Sin = sparse(edges(:,2),edges(:,3),sin(edges(:,5)),n,n);

    [P,timeP] = buildP(n,Cos,Sin);
    
    % why to remove these first line, corresponding to first node (see pdf)
%     count = 0;
%     should = n;
%     while rank(full(M'*M)) ~= should
%         M(1:(n-1),:) = [];
%         P(1:(n-1),:) = [];
%         should = should - 1
%         count = count + 1
%     end

    % 20210207 now we want to exclude the empty rows in P and the
    % respective ones in M
    edgeRows = any(P,2);
    P = P(edgeRows,:);
    M = M(edgeRows,:);
    
    if rank(full(M'*M)) ~= n
%         % to remove x_1 remove rows with first column 1 or -1
%         % is this really what we need?
%         firstEdgeRows = any(M(:,1),2);
%         M(firstEdgeRows,:) = [];
% %         M(1:(n-1),:) = [];
% %         M(1:n:end,:) = [];
        M(:,1) = [];
        
%         P(firstEdgeRows,:) = [];
% %         P(1:(n-1),:) = [];
% %         P(1:n:end,:) = [];
    end
    
    full(P)
    full(M)
    
    sizeM = size(M)
    sizeP = size(P)
    
    rankMM = rank(full(M'*M))
    rankMP = rank(full(M'*P))

%     this one is not encouraged by matlab
%     emb = inv(M'*M)*(M'*P);   
%     this is maybe necessary to keep the matrices in lower dimensions
    emb = (M'*M)\(M'*P);  
%     emb = (M'*M)\M'*P;
    
%     % the minimum norm solution, see testing.mlx link
%     emb = M'*((M*M')\P);
    
    % if we excluded the x_0, we need to update the embedding by x_0 at
    % [0,0]
    if size(M,2) == n-1
        emb = [[0,0];emb];
    end

%     emb = M'*P;
    times = [timeMerg,timeM,timeP];
    times
    
    clearvars timeMerg timeM timeP
    save(append("materials\",pathData,".mat"))
end