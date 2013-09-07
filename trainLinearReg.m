function [theta] = trainLinearReg(X, y, lambda)
%  TRAINLINEARREG Trains linear regression given a dataset (X, y) and a
%  regularization parameter lambda
%  [theta] = TRAINLINEARREG (X, y, lambda) trains linear regression using
%  the dataset (X, y) and regularization parameter lambda. Returns the
%  trained parameters theta.
%

% Initialize Theta
initial_theta = zeros(size(X, 2), 1); 

% Create "short hand" for the cost function to be minimized
costFunction = @(t) linearRegCostFunction(X, y, t, lambda);

% Now, costFunction is a function that takes in only one argument
%options = optimset('MaxIter', 400, 'GradObj', 'on');

% Minimize using fmincg
%theta = fmincg(costFunction, initial_theta, options);

% Initialize Theta for Normal equation
% Normal equation converges much faster than fmincg above.
% All data used is independent and the input matrix is invertible.
initial_theta_normal = eye(size(X, 2)); 
initial_theta_normal(1, 1) = 0;

theta = pinv(X'*X + (lambda .* initial_theta_normal)) * X' * y;

end
