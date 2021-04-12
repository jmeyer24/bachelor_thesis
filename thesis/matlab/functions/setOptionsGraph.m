function setOptionsGraph(figure)
    set(figure,'LineWidth',0.5) 
    set(figure,'LineStyle','-')
    
    if isequal(class(figure),'matlab.graphics.chart.primitive.GraphPlot')
        set(figure,"NodeLabel",{})
        set(figure,"Marker","o")
        set(figure,"MarkerSize",1.5)
    %     set(figure,"NodeColor","red")
    end
    
    % ratios of plot box and tick size
    pbaspect([1 1 1])
    daspect([1 1 1])
    axis padded
end