% Loading the dataset
dataSet = load('TestDataSet.txt');

% Storing the values in seperate vectors 
n = size(dataSet, 2) - 1;
x = dataSet(:, 1:n);
y = dataSet(:, n+1);

% Do you want feature normalization
normalization = true;

% Applying mean normalization to our dataset
if (normalization)
    for i = 1:n
        x(:, i) = (x(:, i) - max(x(:, i))) / (max(x(:, i)) - min(x(:, i)));
    end
    y = (y - max(y)) / (max(y) - min(y));
end

% Adding a column of ones to the beginning of the 'x' matrix
x = [ones(length(x), 1) x];

% Running gradient descent on the data
% 'x' is our input matrix
% 'y' is our output vector
% 'parameters' is a matrix containing our initial parameters
parameters = zeros(n+1, 1);
learningRate = 0.01;
repetition = 15000;
[parameters, costHistory] = gradient(x, y, parameters, learningRate, repetition);

% Plotting our cost function on a different figure to see how we did
figure;
plot( 1:repetition,costHistory);

% Finally predicting the output of the provided inputs
inputs = [6; 6; 6];
output = parameters' .* inputs;
disp(output);