% Plots the data in a cluster either by means of 'dbscan' or 'kmeans' 
% adds the clustering information to the embedding and returns it.
function clusteredEmb = plotCluster(emb,options)
    arguments
        emb (:,2) {mustBeNumeric}
        options.Type (1,1) {mustBeMember(options.Type,["km","db"])} = "km"
        
        % "db"
        options.Epsilon (1,1) double = 6 % threshold for neighborhood search query
        options.Minpts (1,1) {mustBeInteger,mustBePositive} = min(5,size(emb,1)/10) % threshold whether point is core point
        % "km"
        options.NumClusters (1,1) {mustBeInteger} = min(5,size(emb,1)/2)
        
        options.Showlabels (1,1) logical = false
        options.Legend (1,1) {mustBeMember(options.Legend,["on","off"])} = "off"
    end
    
    if issparse(emb)
        emb = full(emb);
    end
    
    if options.Type == "db"
        idx = dbscan(emb,options.Epsilon,options.Minpts);
    elseif options.Type == "km"
        idx = kmeans(emb,options.NumClusters);
    end
    
    numcl = size(unique(idx),1);
    clpos = zeros(numcl,2);
    labels = string(1:numcl);
        
    gscatter(emb(:,1),emb(:,2),idx,'','x',5,options.Legend)
    hold on
    
    for i = 1:numcl
        clpos(i,:) = mean(emb(idx==i,:));
    end
    scatter(clpos(:,1),clpos(:,2),'black')
    
    if options.Showlabels
       text(clpos(:,1),clpos(:,2),labels,"FontSize",15,"HorizontalAlignment","right") 
    end
    
    clusteredEmb = [emb idx];
    
    hold off
end