% calculates the Objective Function with normalization of the difference
function cof = ObjFN(embedding)
    load materials\building.mat edges
    cof = 0;

    for row = 1:size(edges,1)
        edge = edges(row,:);
        from_ind = edge(2);
        to_ind = edge(3);
        angle = edge(5);

        x_diff = NormalizeVector(embedding(to_ind,:)-embedding(from_ind,:));
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
        vec = x;
    else
        vec = x/length;
    end
end