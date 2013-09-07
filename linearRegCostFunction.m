function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%   LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%   regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% Compute the cost and gradient of regularized linear 
% regression for a particular choice of theta.

predictions = X * theta;

J = 1/(2 * m) * sum((predictions - y) .^2);

% Do not get the sum of the first theta term
theta_temp = theta;
theta_temp(1) = 0;

% Get regularized cost
reg_cost = lambda/(2 * m) * sum(theta_temp .^2);
J = J + reg_cost;

% IMPORTANT - The summation is obtained when X is multiplied by the 
% error difference vector
grad = 1/m * (X' * (predictions - y));

% Do not add the first theta term
theta_temp = theta;
theta_temp(1) = 0;

% Get regularized gradient vector
reg_grad = lambda/m .* theta_temp; 
grad = grad + reg_grad;

% =========================================================================

grad = grad(:);

end
