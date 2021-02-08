function plotData(pathData,rereadData,drawEmbedding,drawOV,drawNodes,drawLabel,drawNorth,drawConnections,drawNormalized,drawDifference,drawEndLabel)
    matPath = append("materials\",pathData,".mat");
    
    % draw either the embedding or the given (in the files) data
    % you can choose to check for precalculated .mat files
    if drawEmbedding
        if rereadData
            [nodes,edges,~,emb,~,~,~,~] = build(pathData);
        else
            try
                load(matPath,"nodes","edges","emb");
            catch
                [nodes,edges,~,emb,~,~,~,~] = build(pathData);
            end
        end
        ctitle = "embedding";
    else
        if rereadData
            [nodes,edges,~,~,~,~,~,~] = build(pathData);
        else
            try
                load(matPath,"nodes","edges");
            catch
                [nodes,edges,~,~,~,~,~,~] = build(pathData);
            end
        end
        emb = nodes(:,2:3);
        ctitle = "given";
    end
    
    plot(0,0,"k+")
    hold on
    if drawOV
        title(ctitle);
        % print the objective function values for normalized and
        % non-normalized
%         subtitle(append("OV: ",string(ObjF(emb,edges)),newline,"nOV: ",string(ObjFN(emb,edges))),'FontWeight',"normal");
        subtitle(append("OV: ",string(ObjF(emb,edges)),newline,"nOV: ",string(restrictedObjFN(emb,edges))),'FontWeight',"normal");
    end
    
    % draw the nodes
    if drawNodes
        plot(emb(:,1),emb(:,2),'o',"MarkerSize",15,"Color",[0, 0.4470, 0.7410])
    end
    
    % label the nodes
    if drawLabel
        text(emb(:,1),emb(:,2),string(1:size(emb,1)), ...
            'HorizontalAlignment','center', ...
                'VerticalAlignment',"middle", ...
                "Color",'black', ...
                "FontSize",13, ...
                "FontWeight","bold")
    end
        
    % draw a line indicating the nodes north direction
    if drawNorth
        for n = 1:size(emb,1)
            north = nodes(n,5);

            x = emb(n,1);
            x2 = x + 0.1*cos(north+pi/2);

            y = emb(n,2);
            y2 = y + 0.1*sin(north+pi/2);

            line([x,x2],[y,y2], ...
                'Color','red', ...
                'LineWidth',2)    
        end
    end
    
    % draw the connections
    if drawConnections
        for e = 1:size(edges,1)
            edge = edges(e,:);
            from = edge(2);
            to = edge(3);
            angle = edge(5);
            dist = pdist([emb(from,:);emb(to,:)],"euclidean");

            x = emb(from,1);
            y = emb(from,2);

            if drawNormalized
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
                quiver(x,y,x2-x,y2-y,0) % ,"Color",[0, 0.4470, 0.7410])
            end

            % draw a line from the end of each edge to 
            % the node it should end at
            if drawDifference
                line([x2,emb(to,1)],[y2,emb(to,2)], ...
                    'Color',[.5 .5 .5], ...
                    'LineStyle',':')
            end

            % label the edge ends
            if drawEndLabel
                text(x2,y2,string(to), ...
                    'HorizontalAlignment','center', ...
                        'VerticalAlignment',"middle", ...
                        "Color",[0 0 0])
            end
        end
    end
    
    hold off
    axis padded equal
end