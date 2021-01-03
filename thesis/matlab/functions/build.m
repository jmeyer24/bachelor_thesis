%BUILD Summary of this function goes here
%   Detailed explanation goes here
function [M,P,Sin,Cos,emb1,emb2] = build(pathNodes,pathEdges)
    [~,edges,n] = merg(pathNodes,pathEdges);

    M = buildM(n);

    Cos = sparse(edges(:,2),edges(:,3),cos(edges(:,5)));
    Sin = sparse(edges(:,2),edges(:,3),sin(edges(:,5)));

    P = buildP(n,Cos,Sin);
    
    M(1:(n-1),:) = [];
    P(1:(n-1),:) = [];

    emb1 = inv(M'*M)*(M'*P);
    emb2 = (M'*M)\(M'*P); 
    clearvars -except M P Sin Cos emb1 emb2
    save materials\last_build.mat
end

