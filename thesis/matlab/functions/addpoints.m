function addpoints(numPoints,col1,col2,datapoints)
    color_gradient = [linspace(col1(1),col2(1),numPoints)',linspace(col1(2),col2(2),numPoints)',linspace(col1(3),col2(3),numPoints)'];
    point_gradient = round(linspace(1,size(datapoints,1),numPoints));
    
    hold on
    
    for i = 1:numPoints
        plot(datapoints(point_gradient(i),1),datapoints(point_gradient(i),2),"x",'Color',color_gradient(i,:))
    end
        
    hold off
end

