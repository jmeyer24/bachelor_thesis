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
    
    tiledlayout(1,2);
    
    nexttile
    gplot(Cos,nodes(:,2:3),':xr')
    axis padded
    
    nexttile
    plotColorgradient(n,col1,col2,nodes(:,2:3),true,true)
    axis padded
    
    figure
end
