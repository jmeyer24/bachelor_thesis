%BUILD Summary of this function goes here
%   Detailed explanation goes here
function [nodes,edges,n,emb,M,P,Sin,Cos] = build(pathData)
    [nodes,edges,n] = merg(pathData);

    M = buildM(n);
    
    Cos = sparse(edges(:,2),edges(:,3),cos(edges(:,5)),n,n);
    Sin = sparse(edges(:,2),edges(:,3),sin(edges(:,5)),n,n);

    P = buildP(n,Cos,Sin);
    
    M(1:(n-1),:) = [];
    P(1:(n-1),:) = [];

%     emb1 = inv(M'*M)*(M'*P);
    emb = (M'*M)\(M'*P);
    
    save(append("materials\",pathData,".mat"))
end

