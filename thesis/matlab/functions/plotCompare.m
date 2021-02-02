% creates a tiled layout and plots initial and final embedding with OVs
function plotCompare(pathData)
    tiledlayout(1,2);
    
    nexttile
    plotData(pathData,0,1,1,1,0,1,0,1,0)
    
    nexttile
    plotData(pathData,1,1,1,1,0,1,0,1,0)
    
    figure
end
