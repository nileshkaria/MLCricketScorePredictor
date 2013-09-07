% Use Machine Learning to predict target score in curtailed innings.
%
% Run Normalized Linear Regression with Regularization on data  
% collected from the first innings. Data includes number of balls
% faced, extras given, run rate (runs scored * 6 / balls faced), 
% wickets remaining, partnership since last wicket and total runs.
%
% This will be used to form a multiple dimensional equation 
% representing the performance of the first team. In effect, for  
% the second team to win, at any given point in the match they must be
% one or more runs ahead of where the first team would have been had
% it played in exactly the same way that the second team has played 
% so far.
%
% This predicted score can be obtained by plugging the statistics of 
% the second team into the linear regression equation calculated for
% the first team. If play is stopped at any point in time, the chasing
% team is declared the winner if it is ahead of the predicted score.
%
% Note:
% The training data from the first innings is normalized and the 
% regression parameter lambda is selected on the basis of the 
% least training error. 
%
% Presently, the Duckworth Lewis method is used to predict the 
% target score in curtailed innings. 
% http://static.espncricinfo.com/db/ABOUT_CRICKET/RAIN_RULES/DUCKWORTH_LEWIS.html
%

%% Initialization
clear ; close all; clc

arg_list = argv ();
% Check input
%for i = 1:nargin
%  printf ("%s\n", arg_list{i});
%endfor

%% =========== Load and Visualize Data =============
%  Load the innings data from CSV files. The following 
%  data is loaded into vectors X and y:
%  1) Total balls faced including extra deliveries faced,
%  2) Extras scored
%  3) Net Run Rate (Total Runs Scored  X 6 / Total deliveries including extras)
%  4) Wickets left
%  5) Partnership since last fall of wicket
%  6) Total runs scored

fprintf('Loading and Visualizing Data ...\n')

% Load Training Data - First innings statistics

data = load(strcat("data/", arg_list{1}, "_1.txt"));

%ODIs
%data = load('data/350043_1.txt');
%data = load('data/352665_1.txt');
%data = load('data/377313_1.txt');
%data = load('data/597928_1.txt');
%data = load('data/601612_1.txt');
%data = load('data/602476_1.txt');
%data = load('data/645639_1.txt');
%data = load('data/645641_1.txt');
%data = load('data/474479_1.txt');
%data = load('data/582190_1.txt');
%data = load('data/433606_1.txt');
%data = load('data/566948_1.txt');

%T20
%data = load('data/412685_1.txt');
%data = load('data/412686_1.txt');

X = data(:, 1:5);
y = data(:, 6);

% Calculate the number as a function of the sum of wickets and 
% net run rate. Each fall of wicket or decrease in effective 
% run rate increases this value. Wickets are resources to 
% preserve while maintaining a high run rate. This parameter is
% added to penalize a quick fall of wickets or a drastic decrease 
% in the net run rate and will result in increasing the predicted 
% target score. 
X = [X' ; (y  ./ (X(:,3) .+ X(:,4) + 1))']';

%OR Use Extras
%X = [X' ; (y .^3 ./ (X(:,2) .+ X(:,4) + 1))']';

X(:,3) = 1 ./ (1 + X(:,3));
X(:,4) = 1 ./ (11 - X(:,4));
X(:,5) = 1 ./ (1 + X(:,5));

% Load Training Data - Second innings statistics

data = load(strcat("data/", arg_list{1}, "_2.txt"));

%ODIs
%data = load('data/350043_2.txt');
%data = load('data/352665_2.txt');
%data = load('data/377313_2.txt');
%data = load('data/597928_2.txt');
%data = load('data/601612_2.txt');
%data = load('data/602476_2.txt');
%data = load('data/645639_2.txt');
%data = load('data/645641_2.txt');
%data = load('data/474479_2.txt');
%data = load('data/582190_2.txt');
%data = load('data/433606_2.txt');
%data = load('data/566948_2.txt');

%T20
%data = load('data/412685_2.txt');
%data = load('data/412686_2.txt');

Xval = data(:, 1:5);
yval = data(:, 6);

Xval = [Xval' ; (yval  ./ (Xval(:,3) .+ Xval(:,4) + 1))']';

%OR Use Extras
% Xval = [Xval' ; (yval .^3 ./ (Xval(:,2) .+ Xval(:,4) + 1))']';

Xval(:,3) = 1 ./ (1 + Xval(:,3));
Xval(:,4) = 1 ./ (11 - Xval(:,4));
Xval(:,5) = 1 ./ (1 + Xval(:,5));

% m = Number of deliveries in the first innings
m = size(X, 1);

% n = Number of deliveries in the second innings
n = size(Xval, 1);

%% =========== TEST : Plot First Innings Data =============

% Plot first innings data
%plot(X(:,1), y, 'g-', 'MarkerSize', 5, 'LineWidth', 2);
%axis([min(X(:, 1)), max(X(:, 1)), min(y), max(y)]);
%xlabel('Balls bowled (x)');
%ylabel('Runs scored (y)');
%title(strcat("Match: ", arg_list{1}, ", 1st innings"));
%legend('Actual score', 'location', 'northwest');

%hold on;

%tx = linspace(min(X(:, 1)), max(X(:, 1)), max(X(:, 1)) - min(X(:, 1))+1);
%ty = linspace(min(X(:, 3)), max(X(:, 3)), max(X(:, 3)) - min(X(:, 3))+1);

%[xx, yy] = meshgrid (tx, ty);

%tz = y * ones(1, size(xx, 1));
%surf(tx, ty, tz');

%hold on;

%plot(X, y, 'g-', 'MarkerSize', 5, 'LineWidth', 2);
%xlabel('Balls bowled (x)');
%ylabel('Run rate (y)');
%zlabel('Runs scored (z)');

%fprintf('Program paused. Press enter to continue.\n');
%pause;

%% =========== TEST : Regularized Linear Regression Gradient =============
% Find the Regularized Linear Regression Theta values using the
% raw data. This is for test purposes only.

%theta =  ones(size(X, 2) + 1, 1);
%[J, grad] = linearRegCostFunction([ones(m, 1) X], y, theta, 1);

%fprintf(['Cost at theta = [1 ; 1]: %f\n'], J);
%fprintf(['Gradient at theta = [1 ; 1]:  [%f; %f] \n'], ...
%         grad(1), grad(2));

%fprintf('Program paused. Press enter to continue.\n');
%pause;

%% =========== Train Regularized Linear Regression =============
%  linearRegCostFunction will compute the cost and gradient and
%  trainLinearReg function will use the cost function to train 
%  regularized linear regression.
% 

% Use a range of lambda values to train the linear regression. Choose
% lambda with least error.

%lambda_vec = [-10 -3 -1 -0.3 -0.1 -0.03 -0.01 -0.003 -0.001 0 0.001 0.003 \
%	      0.01 0.03 0.1 0.3 1 3 10]';

lambda_vec = [0];

%for l = 1:length(lambda_vec)

%	 [theta] = trainLinearReg([ones(m, 1) X], y, lambda_vec(l));

%% =========== TEST : Unnormalized Regularized Linear Regression =============

%  Plot fit over the data

%	 plot(X(:, 1), y, 'g-', 'MarkerSize', 5, 'LineWidth', 2)
%	 xlabel('Balls bowled (x)');
%	 ylabel('Runs scored (y)');
%	 title (sprintf('Linear Regression Fit (lambda = %f)', lambda_vec(l)));

%	 hold on;
%	 plot(X(:,1), [ones(m,1) X]*theta, 'r-', 'MarkerSize', 5, 'LineWidth', 2)
%	 hold off;

%	 fprintf('Program paused. Press enter to continue.\n');
%	 pause;
%endfor


%% =========== Normalize Data for Regularized Linear Regression =============
% Normalize test data and feed it to linearRegCostFunction which will
% compute the cost and gradient. The trainLinearReg function will use 
% the cost function to train regularized linear regression.
%

[X_norm, mu, sigma] = featureNormalize(X);  % Normalize
X_norm = [ones(m, 1), X_norm];              % Add Ones

X_norm_val = bsxfun(@minus, Xval, mu);
X_norm_val = bsxfun(@rdivide, X_norm_val, sigma);
X_norm_val = [ones(size(X_norm_val, 1), 1), X_norm_val];           % Add Ones

%% =========== Learning Curve for Regression =============
%  
%  Try running the code with different values of
%  lambda to see how the fit and learning curve change.
%

min_error = 10^10;
min_lambda = 100;

min_X = min(X);
max_X = max(X);
%range = (min_X: 1 : max_X)';
range = (1: 1 : m)';

min_deliveries = n;

if(n > m)
  min_deliveries = m;
endif

for l = 1:length(lambda_vec)

  [theta] = trainLinearReg(X_norm, y, lambda_vec(l));

  % Plot training data and fit
  h = figure(1);
  plot(X(:,1), y, 'g-', 'MarkerSize', 5, 'LineWidth', 2);

  hold on;

  plot(range, X_norm*theta, 'r-', 'MarkerSize', 5 , 'LineWidth', 2)

  legend('Actual score', 'Predicted score', 'location', 'northwest');
  xlabel('Balls bowled (x)');
  ylabel('Runs scored (y)');
  title(strcat("Match: ", arg_list{1}, ", 1st innings"));

  print -deps -color 'first.eps'

  hold off;

  figure(2);

  [error_train, error_val] = learningCurve(X_norm, y, X_norm_val, yval, lambda_vec(l));
  plot(1:m, error_train, 1:m, error_val);

  minv = min(error_train(min_deliveries));
  if (minv < min_error)
     min_error = minv;
     min_lambda = lambda_vec(l);

    fprintf('min value = %f, min lambda = %f\n', min_error, min_lambda);
  endif

  title(sprintf('Normalized Linear Regression Learning Curve (lambda = %f)', lambda_vec(l)));
  xlabel('Number of training examples')
  ylabel('Error')
  axis([0 m 0 300])
  legend('Train', 'Cross Validation')

  fprintf('Normalized Linear Regression (lambda = %f)\n\n\n', lambda_vec(l));
  
  %for i = 1:m
  %fprintf('  \t%d\t\t%f\t%f\n', i, error_train(i), error_val(i));
  %end

  %fprintf('Program paused. Press enter to continue.\n');
  %pause;
endfor

fprintf('min value = %f, min lambda = %f\n', min_error, min_lambda);


%% =========== Use Theta Value for Prediction =============
%  
%  Normalize data from the second innings and use the theta and
%  lambda obtained from the first innings to predict the target 
%  score for the second innings.

% If the number of deliveries in the second innings is greater
% than that of the first innings, add redundant values of the 
% final score to balance the matrix of the first innings.
if(n > m)

  for i=1:n - m
      X = [X; X(m,:)];
      X_norm = [X_norm; X_norm(m,:)];
      y = [y; y(m, :)];
  endfor

      m = n;
endif

fprintf('\nPredicted target to chase.\n\n');

Xpred = [ n ; X(n,2) ; X(n,3) * (X(m,1)/X(n,1))  ; 1.0 ; 1 /(1 + (n/X(m,1)) * y(m)) ; 
	 (n/X(m,1)) * y(m) / (X(n,3) + 11) ]';

predict(X, y, Xpred, yval(n), Xpred, min_lambda,
	strcat("Match: ", arg_list{1}, ", Predicted Target Score"));
	

fprintf('\nProgram paused. Press enter to continue.\n\n');
pause;

%  No extras given through the innings
%  Add epsilon value to assist normalization
if(Xval(1, 2) == Xval(n, 2))
   Xeps = [0:eps:(n - 1)*eps]';
   Xval(:,2) =     Xval(:,2) + Xeps;
endif

%  No wickets lost through the innings
%  Add epsilon value to assist normalization
if(Xval(1, 4) == Xval(n, 4))
   Xeps = [0:eps:(n - 1)*eps]';
   Xval(:,4) =     Xval(:,4) + Xeps;
endif

[X_pred_norm, mu_pred, sigma_pred] = featureNormalize(Xval);  % Normalize
X_pred_norm = [ones(n, 1), X_pred_norm];                      % Add Ones

%Non Normalized result
%predict(X, y, Xval, yval, Xval, min_lambda);

%Normalized result
predict(X_norm, y, X_pred_norm, yval, Xval, min_lambda,
	strcat("Match: ", arg_list{1}, ", 2nd innings"));

fprintf('Program paused. Press enter to continue.\n');
pause;

Xeps = [0:eps:10*eps]';

Xballs = [n-10:1:n]';
Xballs_norm = [n-10:1:n]' + Xeps;

Xextras = X(n,2)+Xeps;
XRR = X(n, 3)+Xeps;
Xwicket = [10:-1:0]';

Xpartnership = ((Xballs ./ X(m,1)) .* y(m)) ./ (11 - Xwicket);
Xrunsperwicket = ((Xballs ./ X(m,1)) .* y(m)) ./ (XRR .+ Xwicket + 1);

%OR Use Extras
%Xrunsperwicket = (yval(n) .^3)*ones(11,1) ./ (Xextras .+ Xwicket + 1);

Xwicket = 1 ./ (11 - Xwicket);
Xpartnership = 1 ./ (1 + Xpartnership);

% Unnormalized result for 11 base cases
Xpred = [ Xballs' ; Xextras' ; XRR' ; Xwicket' ; Xpartnership'; Xrunsperwicket']';
%predict(X, y, Xpred, yval(n)*ones(11,1), Xpred, min_lambda);

Xpred = [ Xballs_norm' ; Xextras' ; XRR' ; Xwicket' ; Xpartnership'; Xrunsperwicket']';

[X_pred_norm, mu_pred, sigma_pred] = featureNormalize(Xpred);  % Normalize
X_pred_norm = [ones(11, 1), X_pred_norm];                      % Add Ones

%Normalized result for 11 base cases
%predict(X_norm, y(n)*ones(m,1), X_pred_norm, yval(n)*ones(11,1), Xpred, min_lambda);

%fprintf('Program paused. Press enter to continue.\n');
%pause;

%% =========== Validation for Selecting Lambda =============
%  validationCurve tests various values of 
%  lambda on a validation set.
%

[lambda_vec, error_train, error_val] = ...
    validationCurve(X_norm, y, X_norm_val, yval);

close all;
plot(lambda_vec, error_train, lambda_vec, error_val);
legend('Train', 'Cross Validation');
xlabel('lambda');
ylabel('Error');

fprintf('lambda\t\tTrain Error\tValidation Error\n');
for i = 1:length(lambda_vec)
	fprintf(' %f\t%f\t%f\n', ...
            lambda_vec(i), error_train(i), error_val(i));
end

fprintf('Program paused. Press enter to continue.\n');
pause;
