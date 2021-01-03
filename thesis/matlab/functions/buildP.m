% create the P matrix, the multiple of M and the current embedding
function P = buildP(n,Cos,Sin)
    fprintf("\nbuilding P...\n");
%     count = 0;
    tic
    
    t_Cos = Cos';
    t_Sin = Sin';
    x = reshape(t_Cos,[],1);
    y = reshape(t_Sin,[],1);
    P = [x,y];
    % remove same index (p_ii)
    P(1:n-1:n*(n-1),:) = [];
    
%     P = zeros(n*(n-1),2);
%     for k = 1:(n*(n-1))
%     %     t = toc;
%     %     msg = num2str(t);
%     %     fprintf(append(repmat('\b',1,count), msg));
%     %     count = numel(msg);
% 
%         iv = i_fnc(k,n);
%         jv = j_fnc(k,n);
%         P(k,:) = [Cos(iv,jv) Sin(iv,jv)];
%     end
%     % fprintf(repmat('\b',1,count),"\n");
%     P = sparse(P);
    toc
end