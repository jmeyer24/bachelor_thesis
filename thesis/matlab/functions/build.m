%BUILD builds matrices and calculates embedding of a given dataset
function [nodes,edges,n,emb,M,P,Sin,Cos] = build(pathData,options)
%     https://de.mathworks.com/help/matlab/matlab_prog/function-argument-validation-1.html
    arguments
        pathData (1,1) string
        options.Modus (1,1) string = "ls"
        options.LearningRate (1,1) double = 0.01
        options.Repetition (1,1) {mustBeNumeric} = 100
        options.InDegree (1,1) logical = false;
    end
    
    [nodes,edges,n,~,~,timeMerg] = merg(pathData,options.InDegree);
    
    [M,timeM] = buildM(n);

    Cos = sparse(edges(:,2),edges(:,3),cos(edges(:,5)),n,n);
    Sin = sparse(edges(:,2),edges(:,3),sin(edges(:,5)),n,n);

    [P,timeP] = buildP(n,Cos,Sin);

    switch options.Modus
        case "gd" %gradient_descent
            
            [emb, ovHistory] = gradientDescent(nodes(:,2:3), edges, options.LearningRate, options.Repetition);
            
%             % plot the calculated embedding
%             figure;
%             plot(emb(:,1),emb(:,2),'rx');
%             axis padded
%             
%             % plot our cost function on a different figure to see how we did
%             figure;
%             plot(1:options.Repetition, ovHistory);
%             axis padded
            
        case "ls" %least_sqaure
            
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

            % print when building
        %     full(P)
        %     full(M)
        %     
        %     sizeM = size(M)
        %     sizeP = size(P)
        %     
        %     rankMM = rank(full(M'*M))
        %     rankMP = rank(full(M'*P))
            %

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

        clearvars timeMerg timeM timeP
    end
    
    try
        save(append("materials\",pathData,".mat"))
    catch
        save(append("materials\",strrep(pathData,"\","_"),".mat"))
    end
end

% implements the gradient process for the initial objective function (objectiveFunction)
function [embedding,ovHistory] = gradientDescent( embedding, edges, learningRate, repetition )
    %   Main algorithm that tries to minimize our cost functions

    % Getting the length of our dataset
    n = size(embedding,1);
    
    % Creating a vector of zeros for storing our cost function history
    ovHistory = zeros(repetition, 1);
    
    % Running gradient descent
    currEmb = embedding;
%     tic
    for i = 1:repetition
        for nodeInd = 1:n
            sum = [0 0];
            currEdges = edges(find(edges(:,2)==nodeInd),:);
            
            for edgeInd = 1:size(currEdges,1)
                angle = currEdges(edgeInd,5);
                currP = [cos(angle) sin(angle)];
                sum = sum + embedding(currEdges(edgeInd,3),:) - embedding(nodeInd,:) - currP;
            end
            
            currEmb(nodeInd,:) = embedding(nodeInd,:) + 2 * learningRate * sum;
            
            % Keeping track of the cost function
            ovHistory(i) = objectiveFunction(embedding,edges); % TODO: specify version of OF
        end
        embedding = currEmb;
    end
% %     toc
%     disp(edges);
end

% builds the M matrix e.g. -1 vector moving through unit matrices
function [M,timeM] = buildM(n)
%     m = [repelem(-1,n-1)' speye(n-1)]; % first block of M
%     [I,J,V] = find(m);
%     ###
%     fprintf("\nbuilding M...\n");
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
%     toc

    % M = zeros(n*(n-1),n);
    % this would be a 19.2GB matrix for n = 1371 XD... 
    % this isnt even the final form of the matrix
    M = sparse(I,J,V);
    clearvars -except M timeM
end

% create the P matrix, e.g. a list of vectors on the unit circle
function [P,timeP] = buildP(n,Cos,Sin)
%     fprintf("\nbuilding P...\n");
    tic
    
    t_Cos = Cos';
    t_Sin = Sin';
    x = reshape(t_Cos,[],1);
    y = reshape(t_Sin,[],1);
    P = [x,y];
    % remove same index (p_ii)
    P(1:n+1:n^2,:) = [];
    
    timeP = toc;
%     toc
    clearvars -except P timeP
end

% see 'merging.mlx'
% takes nodes and edges files and merges stacked nodes to one
function [nodes,edges,n,e,mapping,timeMerg] = merg(pathData,inDegree)
    addpath("extensions\CircStat2012a")

    [nodes,edges] = readBoth(pathData,inDegree);
    
    all_nodes = nodes;
    
%     fprintf("\nmerging...\n");
    tic
    
    % get the indices of rows in nodes, that have first an unique position
    % this results in 1 representative for each group of overlapping nodes
    [~,IA,~] = unique(nodes(:,[2 3]),'rows','stable');
    % grab these representatives
    nodes = nodes(IA,:);  
    % number of representatives
    n = size(nodes,1);
    
    % generate matrices 'from' and 'to' that check to which representative
    % the edge number are lower, e.g. to which rep they are ordered to
    maf = edges(:,2)' < IA;
    mat = edges(:,3)' < IA;
    % redirect the edge 'from' and 'to' nodes to the representatives
    for i = 1:size(edges,1)
        % check for the 'last' 0 and 1 (in matrices) indices
        % the last zero indicates the representative being closest to the
        % 'from' node
        [~,ia,~] = unique(maf(:,i),'last');
        % take the representative index
        ia(1);
        % redirect the edge to the representative
        edges(i,2) = IA(ia(1));
        
        % same for 'to' node of the edge
        [~,ia,~] = unique(mat(:,i),'last');
        edges(i,3) = IA(ia(1));
    end
    
    % delete selfloops after redirection
    selfloops = edges(:,2)==edges(:,3);
    edges(selfloops,:) = [];
    e = size(edges,1);
    
    % rename the representatives in ascending fashion
    mapping = [(1:n)' IA];
    nodes(:,1) = 1:n;
    edges(:,1) = 1:e;
    for i = 1:size(edges,1)
        idx = find(edges(i,2)==mapping(:,2));
        edges(i,2) = idx;

        idx = find(edges(i,3)==mapping(:,2));
        edges(i,3) = idx;
    end
    
    % all representatives get circ_mean bearing
    % the nord direction is for all overlapping the same, so there is no 
    % need to mean them
    for i = 1:n-1
        nodes(i,4) = circ_mean(all_nodes(IA(i):IA(i+1)-1,4));
    end
    nodes(end,4) = circ_mean(all_nodes(IA(n):end,4));

    timeMerg = toc;
%     toc
    clearvars -except nodes edges n e mapping timeMerg
end

% takes a given file path and forms its content to a matrix
function [nodes,edges] = readBoth(pathData,inDegree)
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
    
    if inDegree
        edges(:,5) = deg2rad(edges(:,5))*(-1) + deg2rad(90);
    end
end
