function percentage = checkfilled(mat)
%CHECK computes the percentage of nonzeros in given matrix
    percentage = nnz(mat)/numel(mat);
end

