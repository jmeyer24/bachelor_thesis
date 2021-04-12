% creates a tiled layout and plots 2 distinct visualizations of the given data
% https://de.mathworks.com/help/matlab/ref/tiledlayout.html
% https://de.mathworks.com/matlabcentral/answers/692515-how-do-you-end-a-tiledlayout-object
function plotTiled(pathData)
    matPath = append("materials\",pathData,".mat");
    try
        load(matPath,"nodes","n","Cos"); 
    catch
        [nodes,~,n,~,~,~,~,Cos] = build(pathData);
    end
    
    col1 = [0, 1, 0];
    col2 = [1, 0, 0];
    
    t = tiledlayout(1,2);
    
    nexttile
    gplot(Cos,nodes(:,2:3),':xr')
    axis padded
    
    nexttile
    plotColorgradient(n,col1,col2,nodes(:,2:3),true,true)
    axis padded
    
    figure
end

% adds to an existing graph a number of points from the given matrix
function plotColorgradient(numPoints,col1,col2,datapoints,showLines,plotalldata)
    color_gradient = [linspace(col1(1),col2(1),numPoints)',linspace(col1(2),col2(2),numPoints)',linspace(col1(3),col2(3),numPoints)'];
    point_gradient = round(linspace(1,size(datapoints,1),numPoints));
    
    plot(datapoints(:,1),datapoints(:,2),"w")

    hold on
    
    if showLines
        if plotalldata
            plot(datapoints(:,1),datapoints(:,2),"Color",[0, 0.4470, 0.7410])  % that is the standard blue color
        else
            plot(datapoints(point_gradient,1),datapoints(point_gradient,2),"Color",[0, 0.4470, 0.7410])  % that is the standard blue color
        end
    end
    
    for i = 1:numPoints
        plot(datapoints(point_gradient(i),1),datapoints(point_gradient(i),2),"x",'Color',color_gradient(i,:))
    end
        
    hold off
end