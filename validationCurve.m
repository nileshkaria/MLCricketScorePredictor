function [lambda_vec, error_train, error_val] = ...
    validationCurve(X, y, Xval, yval)
%   VALIDATIONCURVE Generate the train and validation errors needed to
%   plot a validation curve that we can use to select lambda
%   [lambda_vec, error_train, error_val] = ...
%   VALIDATIONCURVE(X, y, Xval, yval) returns the train and validation
%   errors (in error_train, error_val) for different values of lambda. 
%

% Selected values of lambda
lambda_vec = [-10 -3 -1 -0.3 -0.1 -0.03 -0.01 -0.003 -0.001 0 0.001 \
	      0.003 0.01 0.03 0.1 0.3 1 3 10]';

error_train = zeros(length(lambda_vec), 1);
error_val = zeros(length(lambda_vec), 1);

% Return training errors in error_train and the validation
% errors in error_val. The vector lambda_vec contains the
% different lambda parameters to use for each calculation 
% of the errors, i.e, error_train(i), and error_val(i) should
% give you the errors obtained after training with 
% lambda = lambda_vec(i)
%

for i = 1:length(lambda_vec)

  lambda = lambda_vec(i);

  [theta_train] = trainLinearReg(X, y, lambda);

  error_train(i) = linearRegCostFunction(X, y, theta_train, 0);

  error_val(i) = linearRegCostFunction(Xval, yval, theta_train, 0);

endfor

% =========================================================================

end
