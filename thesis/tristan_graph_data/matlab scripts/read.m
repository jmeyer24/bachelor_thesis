function A = read(filename)
    f = fopen(filename);
    C = textscan(f, '%f%f%f%f%f', 'HeaderLines',1);
    fclose(f); 
    A = cell2mat(C);
end