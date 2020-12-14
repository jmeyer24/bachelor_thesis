% get the j index
function x = j_fnc(k,n)
    c_mod = mod(k,n-1);
    if c_mod == 0 || c_mod >= i_fnc(k,n)
        x = c_mod + 1;
    else
        x = c_mod;
    end
end