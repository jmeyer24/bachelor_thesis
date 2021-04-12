function plotSurvey(pathData,options)
    arguments
        pathData (1,1) string
        options.Which (1,1) string = "both"
        options.Modus (1,1) string = "ls"
        options.Ov (1,1) logical = false
        options.Title (1,1) logical = false
    end
    
    % check which participant the graphs belong to and titleString the graph
    % accordingly as number of VP
    name = extractAfter(pathData,"survey_");
    switch name
        case "theo"
            titleString = "VP1";
        case "jakob"
            titleString = "VP2";
        case "ronja"
            titleString = "VP3";
        case "helmut"
            titleString = "VP4";
        case "leia"
            titleString = "VP5";
        case "birgit"
            titleString = "VP6";
        case "correct"
            titleString = "correct";
    end
    
    switch options.Modus
        case "ls"
            titleString = titleString + " - least square";
        case "gd"
            titleString = titleString + " - gradient descent";
    end
    
    % start the new figure
    figure 
    
    % print different modi of plots depending on the input "which"
    switch options.Which
        case "both"     
            t = tiledlayout(1,2);

            nexttile
            plotVisualization(pathData,"Modus",options.Modus,"InDegree",true,"Which",'given',"Title",options.Title,"Ov",options.Ov)

            nexttile
            plotVisualization(pathData,"Modus",options.Modus,"InDegree",true,"Which",'embedding',"Title",options.Title,"Ov",options.Ov)

        case "bothPerception"     
            t = tiledlayout(1,2);

            nexttile
            plotData(pathData,"Modus",options.Modus,"InDegree",true,"RereadData",true,"Nodes",true,"Connections",true,"Difference",true,"Title",options.Title,"Ov",options.Ov)
            
            nexttile
            plotData(pathData,"Modus",options.Modus,"InDegree",true,"RereadData",true,"Embedding",true,"Nodes",true,"Connections",true,"Difference",true,"Title",options.Title,"Ov",options.Ov)
    
        case "four"
            % TODO!!!
            % print in the second graph not the embedding but the given graph
            % with the perceived angles (plotCompare style)
            t = tiledlayout(2,2);

            % given graph
            nexttile
            plotVisualization(pathData,"Modus",options.Modus,"InDegree",true,"Which",'given',"Title",options.Title,"Ov",options.Ov)
            
            % embedding graph
            nexttile
            plotVisualization(pathData,"Modus",options.Modus,"InDegree",true,"Which",'embedding',"Title",options.Title,"Ov",options.Ov)
            
            % given perception
            nexttile
            plotData(pathData,"Modus",options.Modus,"InDegree",true,"RereadData",true,"Nodes",true,"Connections",true,"Difference",true,"Title",options.Title,"Ov",options.Ov)
            
            % embedding perception
            nexttile
            plotData(pathData,"Modus",options.Modus,"InDegree",true,"RereadData",true,"Embedding",true,"Nodes",true,"Connections",true,"Difference",true,"Title",options.Title,"Ov",options.Ov)


        case "givenPerception"
            t = tiledlayout(1,1);

            nexttile
            plotData(pathData,"Modus",options.Modus,"InDegree",true,"RereadData",true,"Nodes",true,"Connections",true,"Difference",true,"Title",options.Title,"Ov",options.Ov)
        
        case "embeddingPerception"
            t = tiledlayout(1,1);

            nexttile
            plotData(pathData,"Modus",options.Modus,"InDegree",true,"RereadData",true,"Embedding",true,"Nodes",true,"Connections",true,"Difference",true,"Title",options.Title,"Ov",options.Ov)
        
        case "given"
            t = tiledlayout(1,1);

            nexttile
            plotVisualization(pathData,"Modus",options.Modus,"InDegree",true,"Which",'given',"Title",options.Title,"Ov",options.Ov)
        
        case "embedding"
            t = tiledlayout(1,1);

            nexttile
            plotVisualization(pathData,"Modus",options.Modus,"InDegree",true,"Which",'embedding',"Title",options.Title,"Ov",options.Ov)
    
        case "overlay"
            t = tiledlayout(1,1);

            nexttile
            plotVisualization(pathData,"Modus",options.Modus,"InDegree",true,"Which",'overlay',"Title",options.Title,"Ov",options.Ov)
            
%             set(gca,'visible','off')
%             box on;
    end
    
    % title the plots accordingly and save it in the respective directory
%     t.Title.String = titleString;
%     t.Title.FontWeight = 'bold';
% TODO richte den Title so aus, dass er über den nexttile graphen liegt...
    if options.Title
        title(t,titleString,"FontWeight","bold","Alignment","top");
    end
    
    exportgraphics(t,append("plots\survey\",options.Which,"\",name,".png"),"Resolution",300);
    
end

function plotVisualization(pathData,options,drawing)  
    arguments
        pathData (1,1) string
        options.InDegree (1,1) logical = false
        options.Which (1,1) string = "given"
        options.Modus (1,1) string = "ls"
        options.Overlay (1,1) logical = false
        drawing.Xnormalized (1,1) logical = false
        drawing.P(1,1) logical = false
        drawing.FitP (1,1) logical = false
        drawing.Difference (1,1) logical = false
        drawing.Title (1,1) logical = false
        drawing.Ov (1,1) logical = false
    end

    % draw either the embedding or the given (in the files) data
    % you can choose to check for precalculated .mat files
    [nodes,edges,~,emb,~,~,~,~] = build(pathData,"Modus",options.Modus,"InDegree",options.InDegree);
    scaleToNode = 7;
    
    plot(0,0,"k+")
    hold on
    
    switch options.Which
        case "given"
            emb = nodes(:,2:3);
        case "overlay"
            options.Overlay = true;
    end
    
    if drawing.Title
        title(options.Which)
    end
    
    if drawing.Ov
        subtitle(append("OV: ",string(objectiveFunction(emb,edges)),newline,"nOV: ",string(objectiveFunction(emb,edges,"Version","fitted"))),'FontWeight',"normal");
    end
    
    % draw the nodes
    plot(emb(:,1),emb(:,2),'o',"MarkerSize",10,"Color",[0, 0, 0])
    
    % draw the options.Overlay
    if options.Overlay
        % scale such that the distance between loeschenmuehle and
        % unterahorn are the same (no rotation though)
        scaling = norm(emb(scaleToNode,:)) / norm(nodes(scaleToNode,2:3));
        overlayEmb = nodes(:,2:3) * scaling;
        plot(overlayEmb(:,1),overlayEmb(:,2),'o',"MarkerSize",10,"Color","green")%[0.6, 0.6, 0.6])
        % draw the differences between options.Overlay (given) and embedding
        for n = 1:size(nodes,1)
            line([emb(n,1),overlayEmb(n,1)],[emb(n,2),overlayEmb(n,2)], ...
                'LineStyle','-', ...
                'Color',[0.8902, 0.1882, 0.1882])
        end
    end
    
    % draw the connecting edges as vectors
    for e = 1:size(edges,1)
        edge = edges(e,:);
        from = edge(2);
        to = edge(3);
        angle = edge(5);

        x = emb(from,1);
        y = emb(from,2);
            
        x2 = emb(to,1);
        y2 = emb(to,2);
        
        dist = pdist([[x,y];[x2,y2]],"euclidean");

        % draw the normalized versions of the edges, not really visible for
        % the given one, as the scales are too big then
        if drawing.Xnormalized
            no = norm([x2-x,y2-y]);
            line([x,x2],[y,y2],"Color",[0.5,0.5,0.5],"LineStyle",":")
        else
            no = 1;
        end
        
        % if we do only one graph in the plot, draw the edges
        if ~options.Overlay
            quiver(x,y,(x2-x)/no,(y2-y)/no,0,"Color",[0, 0, 0]) %[0, 0.4470, 0.7410])
        end
        
        % draw the vectors for the angles given in the data
        if drawing.P
            % if fit, don't use unit vectors but the actual distances
            if drawing.FitP
                x2p = x + dist * cos(angle);
                y2p = y + dist * sin(angle);
            else
                x2p = x + cos(angle);
                y2p = y + sin(angle);
            end
            quiver(x,y,x2p-x,y2p-y,0,"Color",[0.1882, 0.7608, 0.0980]) %[0, 0.4470, 0.7410])
            
            % draw a line from the end of each perception vector to the
            % node it should end at
            if drawing.Difference
                line([x2p,x+(x2-x)/no],[y2p,y+(y2-y)/no], ...
                    'LineStyle','-.', ...
                    'Color',[0.8902, 0.1882, 0.1882])
            end
        end
    end
    
    hold off
    axis padded square equal
end
