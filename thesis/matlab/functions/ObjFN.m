% calculates the Objective Function with normalization of the difference
function cof = ObjFN(emb,edges)
    cof = 0;

    for row = 1:size(edges,1)
        edge = edges(row,:);
        from = edge(2);
        to = edge(3);
        angle = edge(5);

        x_diff = NormalizeVector(emb(to,:)-emb(from,:));
        x_unitvec = [cos(angle) sin(angle)];
        
        vec_ij = x_diff - x_unitvec;
        z = sum(vec_ij.*vec_ij);

        cof = cof + z;
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