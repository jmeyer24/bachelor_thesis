% adds to an existing graph a number of points from the given matrix
function plotcolorgradient(numPoints,col1,col2,datapoints,showLines,plotalldata)
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

