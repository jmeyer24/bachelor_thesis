function [adj_delaunay,emb_delaunay,emb_force,emb_subspace,edges_mcs] = generateGraphs(perc,n,seed,options)
    arguments
        perc (1,1) double {mustBeInRange(perc,0,1)} = 0.5
        n (1,1) {mustBeInteger,mustBePositive} = 1000
        seed (1,1) {mustBeNumeric} = 1409 %392
        options.PlotAll (1,1) logical = false
        options.OnlyDelaunay (1,1) logical = false
    end
    
    % first create the folder to save plots and embeddings
    pathPlot = "plots\mcs\" + n + "_" + seed;
    pathData = "data\mcs\" + n + "_" + seed;
    
    % set random seed to be able to recompute
    rng(seed)
    
    try
        load("materials\mcs\" + n + "_" + seed + ".mat", "dt", "emb_delaunay", "edges_full", "g", "adj_delaunay");
    catch
        % generate plot by delaunaytriangulation
        dt = delaunayTriangulation(randn(n,2));
        emb_delaunay = dt.Points;
        % generate the corresponding edges to save both
        dtCL = dt.ConnectivityList;
        edges_full = [dtCL(:,[1 2]); dtCL(:,[2 1]); dtCL(:,[1 3]); dtCL(:,[3 1]); dtCL(:,[2 3]); dtCL(:,[3 2])];
        saveData(emb_delaunay,edges_full,pathData,0.0,"delaunay")

        % graph from delaunayTriangulation
        A = sparse(dt.ConnectivityList, dt.ConnectivityList(:, [2:end 1]), 1);
        g = graph(A + A');
        adj_delaunay = A + A';
        
        save("materials\mcs\" + n + "_" + seed + ".mat", "dt", "emb_delaunay", "edges_full", "g", "adj_delaunay")
    end
    
    if ~options.OnlyDelaunay
        % plot the non-sparsified versions
        if options.PlotAll
            figure
            g_delaunay = plot(g,'XData', dt.Points(:, 1), 'YData', dt.Points(:, 2));
            setOptionsGraph(g_delaunay);
            title("delaunay")
            
            try
                exportgraphics(gcf,pathPlot + "\0.0_delaunay.png","Resolution",300);
            catch
                mkdir(pathPlot)
                exportgraphics(gcf,pathPlot + "\0.0_delaunay.png","Resolution",300);
            end
            
            figure
            g_force = plot(g,"Layout","force",'Iterations',50);
            setOptionsGraph(g_force);
            title("force50")
            exportgraphics(gcf,pathPlot + "\0.0_force50.png","Resolution",300);
            emb_force = [g_force.XData' g_force.YData'];
            saveData(emb_force,edges_full,pathData,0.0,"force50")
            
            figure
            g_subspace = plot(g,"Layout","subspace");
            setOptionsGraph(g_subspace);
            title("subspace")
            exportgraphics(gcf,pathPlot + "\0.0_subspace.png","Resolution",300);
            emb_subspace = [g_subspace.XData' g_subspace.YData'];
            saveData(emb_subspace,edges_full,pathData,0.0,"subspace")
        end
    
        % subset extraction
        % remove "perc" percent of edges
        e = size(g.Edges,1);
        rm_idx = sort(randsample(e,round(e*perc)));
        endnodes = g.Edges.EndNodes;
        g1 = rmedge(g,endnodes(rm_idx,1),endnodes(rm_idx,2));
        % or remove same percentage of nodes not edges
%         g1 = rmnode(g,rm_idx);
        
        % get connected component
        [bin,binsize] = conncomp(g1);
        idx = binsize(bin) == max(binsize);
        sg1 = subgraph(g1, idx);
        edges_mcs = [sg1.Edges.EndNodes; sg1.Edges.EndNodes(:,[2 1])];
        
        % plot all unconnected subgraphs
    %     figure
    %     plot(g1)
    %     title("edge sparsification " + perc)
    %     axis equal
    %     exportgraphics(gcf,path + "\" + perc + "_sparsified.png","Resolution",300);
        
        % plot maximum connected subgraphs (mcs)
        figure
        emb_delaunay = dt.Points(idx,:);
        g_delaunay = plot(sg1,"XData",emb_delaunay(:,1),"YData",emb_delaunay(:,2));
        setOptionsGraph(g_delaunay);
        title("mcs" + perc + " delaunay")
        exportgraphics(gcf,pathPlot + "\" + perc + "_delaunay.png","Resolution",300);
        saveData(emb_delaunay,edges_mcs,pathData,perc,"subspace");

        figure
        g_force = plot(sg1,"Layout","force","Iterations",50);
        setOptionsGraph(g_force);
        title("mcs" + perc + " force50")
        exportgraphics(gcf,pathPlot + "\" + perc + "_force50.png","Resolution",300);
        emb_force = [g_force.XData' g_force.YData'];
        saveData(emb_force,edges_mcs,pathData,perc,"force50")
        
        figure
        g_subspace = plot(sg1,"Layout","subspace");
        setOptionsGraph(g_subspace);
        title("mcs" + perc + " subspace")
        exportgraphics(gcf,pathPlot + "\" + perc + "_subspace.png","Resolution",300);
        emb_subspace = [g_subspace.XData' g_subspace.YData'];
        saveData(emb_subspace,edges_mcs,pathData,perc,"subspace");
    end
end

function saveData(emb,edg,pathData,perc,type)
    arguments
        emb (:,2) {mustBeNumeric}
        edg (:,2) {mustBeNumeric}
        pathData (1,1) string
        perc (1,1) {string,mustBeNumeric}
        type (1,1) string
    end
    
    path = pathData + "\" + perc + "_" + type + "\";
    
    %%% save the nodes
    n = size(emb,1);
    % north vote etc
    nodes = [(1:n)' emb zeros(n,2)];
    % add column names and first zero point (initialization by tristan)
    nodes = [["label" "xPos" "yPos" "vote" "north"]; zeros(1,5); nodes];

    %%% save the edges
    e = size(edg,1);    % angles etc   
    % compute the angles for the edges (with some jitter)
    distances = zeros(1,e);
    angles = zeros(1,e);
    count = 0;
    for i = 1:e
        from = edg(i,1);
        to = edg(i,2);
        count = count + 1;
        
        distance = norm(emb(to,:)-emb(from,:));
%         angle = pi/2 - atan2(emb(to,2)-emb(from,2),emb(to,1)-emb(from,1));
        angle = atan2(emb(to,2)-emb(from,2),emb(to,1)-emb(from,1));
        distances(count) = distance;
        angles(count) = angle;
    end
    
    % add angles and column names
    edges = [edg (1:e)' distances' angles']; 
    edges = [["from" "to" "label" "distance" "angle"]; edges];
    
    try
        writematrix(nodes, path + "nodes.txt", 'Delimiter','tab');    
        writematrix(edges, path + "edges.txt", 'Delimiter','tab');    
    catch
        mkdir(path)
        writematrix(nodes, path + "nodes.txt", 'Delimiter','tab');   
        writematrix(edges, path + "edges.txt", 'Delimiter','tab');   
    end
end
