% create the P matrix, e.g. a list of vectors on the unit circle
function [P,timeP] = buildP(n,Cos,Sin)
    fprintf("\nbuilding P...\n");
    tic
    
    t_Cos = Cos';
    t_Sin = Sin';
    x = reshape(t_Cos,[],1);
    y = reshape(t_Sin,[],1);
    P = [x,y];
    % remove same index (p_ii)
    P(1:n+1:n^2,:) = [];
    
    timeP = toc;
    toc
    clearvars -except P timeP
end