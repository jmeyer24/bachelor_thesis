function plotAngle(pathData,ctitle,drawNodes,drawLabel,drawNorth,drawNormalized,drawDifference,drawEndLabel)
    matPath = append("materials\",pathData,".mat");
    try
        load(matPath,"nodes","edges");  
    catch
        [nodes,edges,~,~,~,~,~,~] = build(pathData);
    end
    
    figure
    hold on
    if (ischar(ctitle) || isstring(ctitle))
        title(ctitle,'FontWeight',"normal")
    end
    
    % draw the nodes
    if drawNodes
        plot(nodes(:,2),nodes(:,3),'o',"MarkerSize",15)
    end
    
    % label the nodes
    if drawLabel
        text(nodes(:,2),nodes(:,3),string(1:size(nodes,1)), ...
            'HorizontalAlignment','center', ...
                'VerticalAlignment',"middle", ...
                "Color",'black', ...
                "FontSize",13, ...
                "FontWeight","bold")
    end
        
    % draw a line indicating the nodes north direction
    if drawNorth
        for n = 1:size(nodes,1)
            north = nodes(n,5);

            x = nodes(n,2);
            x2 = x + 0.1*cos(north+pi/2);

            y = nodes(n,3);
            y2 = y + 0.1*sin(north+pi/2);

            line([x,x2],[y,y2], ...
                'Color','red', ...
                'LineWidth',2)    
        end
    end
    
    % draw the connections
    for e = 1:size(edges,1)
        edge = edges(e,:);
        from = edge(2);
        to = edge(3);
        angle = edge(5);
        dist = pdist([nodes(from,2:3);nodes(to,2:3)],"euclidean");
        
        x = nodes(from,2);
        y = nodes(from,3);
        
        if drawNormalized
            x2 = x + cos(angle);
            y2 = y + sin(angle);

            % draw normalized edges from nodes in angles
            line([x,x2],[y,y2], ...
                'LineWidth',0.5, ...
                'LineStyle','-.')
%                 'Color',[.5,.5,.5], ...
        else
            x2 = x + dist*cos(angle);
            y2 = y + dist*sin(angle);

            % draw the edges from nodes in angles
            line([x,x2],[y,y2])
        end
        
        % draw a line from the end of each edge to 
        % the node it should end at
        if drawDifference
            line([x2,nodes(to,2)],[y2,nodes(to,3)], ...
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
    
    hold off
    axis padded equal
end