%builds the M matrix e.g. -1 vector moving through unit matrices
function [M,timeM] = buildM(n)
%     m = [repelem(-1,n-1)' speye(n-1)]; % first block of M
%     [I,J,V] = find(m);
    fprintf("\nbuilding M...\n");
%     count = 0;
    tic
    
    % preparation
    order = n*(n-1);
    I = repmat(1:order,1,2);
    I = I(:);
    
    jminus = repmat(1:n,n-1,1);
    jminus = jminus(:);
    jplus = zeros(order,1);
    a = 1:n;
    for i = 1:n
        tmp = a;
        tmp(i) = [];
        jplus((n-1)*(i-1)+1:i*(n-1)) = tmp(:);
    end
    J = [jminus; jplus];
    J = J(:);
    
    V = repmat([-1 1],order,1);
    V = V(:);
    
%     for k = 1:(n-1)
%         t = toc;
%         msg = num2str(t);
%         fprintf(append(repmat('\b',1,count), msg));
%         count = numel(msg);
%         m(:,[k k+1]) = m(:,[k+1 k]);
%         [i,j,v] = find(m);
%         I = [I;i+(k*(n-1))];
%         J = [J;j];
%         V = [V;v];
%     end
%     fprintf(repmat('\b',1,count),"\n");
    timeM = toc;
    toc

    % M = zeros(n*(n-1),n);
    % this would be a 19.2GB matrix for n = 1371 XD... 
    % this isnt even the final form of the matrix
    M = sparse(I,J,V);
    clearvars -except M timeM
end