function [error_train, error_val] = ...
    learningCurve(X, y, Xval, yval, lambda)
%   LEARNINGCURVE Generates the train and cross validation set errors needed 
%   to plot a learning curve
%   [error_train, error_val] = ...
%       LEARNINGCURVE(X, y, Xval, yval, lambda) returns the train and
%       cross validation set errors for a learning curve. In particular, 
%       it returns two vectors of the same length - error_train and 
%       error_val. Then, error_train(i) contains the training error for
%       i examples (and similarly for error_val(i)).
%
%   This function will compute the train and test errors for
%   dataset sizes from 1 up to m.
%

% Number of training examples
m = size(X, 1);

% You need to return these values correctly
error_train = zeros(m, 1);
error_val   = zeros(m, 1);


%  Evaluate the training error on the first i training
%  examples (i.e., X(1:i, :) and y(1:i)).
%
%  For the cross-validation error, evaluate on
%  the _entire_ cross validation set (Xval and yval).
%l
% Note: If you are using your cost function (linearRegCostFunction)
%       to compute the training and cross validation error, you should 
%       call the function with the lambda argument set to 0. 
%       Do note that you will still need to use lambda when running
%       the training to obtain the theta parameters.
%

for i = 1:m
  [theta_train] = trainLinearReg(X(1:i, :), y(1:i, :), lambda);

  error_train(i) = linearRegCostFunction(X(1:i, :), y(1:i, :), theta_train, 0);

  error_val(i) = linearRegCostFunction(Xval, yval, theta_train, 0);

endfor

% -------------------------------------------------------------

% =========================================================================

end
