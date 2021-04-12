function [ parameters, costHistory ] = gradient( x, y, parameters, learningRate, repetition )
    %   Main algorithm that tries to minimize our cost functions
    
    % Getting the length of our dataset
    m = length(y);
    n = length(parameters);
    
    % Creating a vector of zeros for storing our cost function history
    costHistory = zeros(repetition, 1);
    
    % Creating a vector for storing our parameter caches
    parameterCaches = zeros(n, 1);
    
    % Running gradient descent
    for i = 1:repetition
        
        % Calculating the transpose of our hypothesis
        h = (x * parameters - y)';
        
        % Caching the new theta and slope for simultaneous update
        for j = 1:n
            parameterCaches(j) = parameters(j) - learningRate * (1/m) * h * x(:, j);
        end
        
        % Updating the parameters simultaneously
        for j = 1:n
            parameters(j) = parameterCaches(j);
        end
        
        % Keeping track of the cost function
        costHistory(i) = cost(x, y, parameters);
        
    end
    
end

