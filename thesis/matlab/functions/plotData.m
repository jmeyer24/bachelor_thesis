function p = plotData(pathData,options,drawing)
    arguments
        pathData (1,1) string
        
        options.Modus (1,1) string = "ls"
        options.InDegree (1,1) logical = false;
        options.RereadData (1,1) logical = false;
        
        drawing.Embedding (1,1) logical = false;
        drawing.Title (1,1) logical = false;
        drawing.Ov (1,1) logical = true;
        drawing.Nodes (1,1) logical = false;
        drawing.Label (1,1) logical = false;
        drawing.North (1,1) logical = false;
        drawing.Connections (1,1) logical = true;
        drawing.Difference (1,1) logical = false;
        drawing.Normalized (1,1) logical = false;
        drawing.EndLabel (1,1) logical = false;        
    end

    matPath = append("materials\",pathData,".mat");
    
    % draw either the embedding or the given (in the files) data
    % you can choose to check for precalculated .mat files
    if drawing.Embedding
        if options.RereadData
            [nodes,edges,~,emb,~,~,~,~] = build(pathData,"Modus",options.Modus,"InDegree",options.InDegree);
        else
            try
                load(matPath,"nodes","edges","emb");
            catch
                [nodes,edges,~,emb,~,~,~,~] = build(pathData,"Modus",options.Modus,"InDegree",options.InDegree);
            end
        end
        ctitle = "embedding";
    else
        if options.RereadData
            [nodes,edges,~,~,~,~,~,~] = build(pathData,"Modus",options.Modus,"InDegree",options.InDegree);
        else
            try
                load(matPath,"nodes","edges");
            catch
                [nodes,edges,~,~,~,~,~,~] = build(pathData,"Modus",options.Modus,"InDegree",options.InDegree);
            end
        end
        emb = nodes(:,2:3);
        ctitle = "given";
    end
    
    p = plot(0,0,"k+");
    hold on
    
    if drawing.Title
        title(ctitle);
    end
    
    if drawing.Ov
        % print the objective function values for normalized and
        % non-normalized
%         subtitle(append("OV: ",string(objectiveFunction(emb,edges)),newline,"nOV: ",string(objectiveFunction(emb,edges,"Version","normalized"))),'FontWeight',"normal");
        subtitle(append("OV: ",string(objectiveFunction(emb,edges)),newline,"nOV: ",string(objectiveFunction(emb,edges,"Version","fitted"))),'FontWeight',"normal");
    end
    
    % draw the nodes
    if drawing.Nodes
        plot(emb(:,1),emb(:,2),'o',"MarkerSize",2,"MarkerFaceColor",[0,0,0],"Color",[0,0,0]) %[0, 0.4470, 0.7410])
    end
    
    % label the nodes
    if drawing.Label
        text(emb(:,1),emb(:,2),string(1:size(emb,1)), ...
            'HorizontalAlignment','center', ...
                'VerticalAlignment',"middle", ...
                "Color",'black', ...
                "FontSize",13, ...
                "FontWeight","bold")
    end
        
    % draw a line indicating the nodes north direction
    if drawing.North
        for n = 1:size(emb,1)
            north = nodes(n,5);

            x = emb(n,1);
%             x2 = x + 0.1*cos(north+pi/2);
            x2 = x + 0.1*cos(north);

            y = emb(n,2);
%             y2 = y + 0.1*sin(north+pi/2);
            y2 = y + 0.1*sin(north);

            line([x,x2],[y,y2], ...
                'Color','red', ...
                'LineWidth',2)    
        end
    end
    
    % draw the connections
    if drawing.Connections
        for e = 1:size(edges,1)
            edge = edges(e,:);
            from = edge(2);
            to = edge(3);
            angle = edge(5);
            dist = pdist([emb(from,:);emb(to,:)],"euclidean");

            x = emb(from,1);
            y = emb(from,2);

            if drawing.Normalized
                x2 = x + cos(angle);
                y2 = y + sin(angle);

                % draw normalized edges from nodes in angles
                line([x,x2],[y,y2], ...
                    'LineWidth',0.5, ...
                    'LineStyle','-.')
            else
                x2 = x + dist*cos(angle);
                y2 = y + dist*sin(angle);

                % draw the edges from nodes in angles
%                 line([x,x2],[y,y2])
                %quiver(x,y,x2-x,y2-y,0,"Color",[0, 0.4470, 0.7410],'LineStyle',':')
                line([x,x2],[y,y2],"Color",[0, 0.4470, 0.7410],'LineStyle',':')
            end

            % draw a line from the end of each edge to 
            % the node it should end at
            if drawing.Difference
                line([x2,emb(to,1)],[y2,emb(to,2)], ...
                    'Color','red', ...
                    'LineStyle','-')
                    %'Color',[.5 .5 .5], ...
                    %'LineStyle',':')
            end

            % label the edge ends
            if drawing.EndLabel
                text(x2,y2,string(to), ...
                    'HorizontalAlignment','center', ...
                        'VerticalAlignment',"middle", ...
                        "Color",[0 0 0])
            end
        end
    end
    
    hold off
    axis padded square equal
end