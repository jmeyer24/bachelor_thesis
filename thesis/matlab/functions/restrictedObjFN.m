% normalized objective function in range 0 (worst) to 1 (best) OV
function ov = restrictedObjFN(emb,edges)
    ov = ObjFN(emb,edges);
    
    % restriction to range [0,1]
    % for explanation see respective live script
    num_edges = size(edges,1);
    ov = abs((ov/(2*num_edges))-1);
end

