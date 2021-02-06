% calculates the Objective Function
function cof = ObjF(emb,edges)
    cof = 0;

    for row = 1:size(edges,1)
        edge = edges(row,:);
        from = edge(2);
        to = edge(3);
        angle = edge(5);

        x_diff = emb(to,:)-emb(from,:);
        x_unitvec = [cos(angle) sin(angle)];

        vec_ij = x_diff - x_unitvec;
        z = sum(vec_ij.*vec_ij);

        cof = cof + z;
    end
end