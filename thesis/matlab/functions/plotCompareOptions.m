% creates a tiled layout and plots initial and final embedding with OVs
function plotCompareOptions(pathData,drawOV,drawNodes,drawLabel,drawNorth,drawConnections,drawNormalized,drawDifference,drawEndLabel,dataOptions)
    rereadData = dataOptions(1);
    savePlot = dataOptions(2);
    
    t = tiledlayout(1,2);
    t.Title.String = pathData;
    t.Title.FontWeight = 'bold';
    
    nexttile
    plotData(pathData,rereadData,0,drawOV,drawNodes,drawLabel,drawNorth,drawConnections,drawNormalized,drawDifference,drawEndLabel)
    
    nexttile
    % 0 for rereadData, as we calculate it in the call above if desired
    plotData(pathData,0,1,drawOV,drawNodes,drawLabel,drawNorth,drawConnections,drawNormalized,drawDifference,drawEndLabel)
    
    figure
    
    if savePlot
        exportgraphics(t,append("plots\",pathData,"_option.png"),"Resolution",300);
    end
end
