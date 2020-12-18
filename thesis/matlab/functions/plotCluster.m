function plotCluster(dat,epsilon,minpts,legend,showlabels,type) 
    if type == "db"
        idx = dbscan(dat(:,2:3),epsilon,minpts);
    elseif type == "km"
        idx = kmeans(dat(:,2:3),minpts);
    end
    
    numcl = size(unique(idx),1)
    clpos = zeros(numcl,2);
    labels = string(1:numcl);
        
    gscatter(dat(:,2),dat(:,3),idx,'','x',minpts,legend)
    hold on
    
    for i = 1:numcl
        clpos(i,:) = mean(dat(idx==i,2:3));
    end
    scatter(clpos(:,1),clpos(:,2),'black')
    if showlabels
       text(clpos(:,1),clpos(:,2),labels) 
    end
        
    hold off
end