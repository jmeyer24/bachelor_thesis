% calculates the Objective Function for the specified version
function ov = objectiveFunction(emb,edges,options)
    arguments
        emb (:,2) {mustBeNumeric} = randn(15,2) % some random embedding for 15 points
        edges (:,5) {mustBeNumeric} = abs(round(randn(10,5)*4))+1 % some random positive matrix for the edges
        options.Version (1,1) string = "initial"
    end
    
    % the variable holding the objective value
    ov = 0;
    
    % options for versions are "initial", "normalized" and "fitted"
    switch options.Version
        
        % get the sum of squared magnitude of the difference between
        % between points vector x and direction/angle vector p
        case "initial"
            for row = 1:size(edges,1)
                edge = edges(row,:);
                from = edge(2);
                to = edge(3);
                angle = edge(5);

                x_diff = emb(to,:)-emb(from,:);
                x_unitvec = [cos(angle) sin(angle)];

                vec_ij = x_diff - x_unitvec;
                z = sum(vec_ij.*vec_ij);

                ov = ov + z;
            end
            
        % normalize the between points vector x before the difference
        case "normalized"
            for row = 1:size(edges,1)
                edge = edges(row,:);
                from = edge(2);
                to = edge(3);
                angle = edge(5);

                x_diff = NormalizeVector(emb(to,:)-emb(from,:));
                x_unitvec = [cos(angle) sin(angle)];

                vec_ij = x_diff - x_unitvec;
                z = sum(vec_ij.*vec_ij);

                ov = ov + z;
            end
            
        % normalized objective function in range 0 (worst) to 1 (best) OV
        case "fitted"
            ov = objectiveFunction(emb,edges,"Version","normalized");

            % restriction to range [0,1]
            % for explanation see respective live script
            num_edges = size(edges,1);
            ov = abs((ov/(2*num_edges))-1);
            
    end
end

function vec = NormalizeVector(x)
    length = sqrt(sum(x.*x));
    if length == 0
        % TODO:
        % what to do when they lay on top of each other?
        % return the 0 vector again or
        % return a unit vector in the given direction?
        angle = atan2(x(2),x(1));
        vec = [cos(angle) sin(angle)];
    else
        vec = x/length;
    end
end