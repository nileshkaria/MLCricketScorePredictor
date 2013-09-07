function lambda_vec = predict(Xfirst, Yfirst, Xinput, Ysecond, \
			      Xsecond, lambda, text)

% Use the lambda value given along with the first innings' normalized 
% statistics to calculate the theta parameters for the regularized
% linear regression equation. 
  m = size(Xinput, 1);

  [theta_train] = trainLinearReg(Xfirst, Yfirst, lambda);

% Plug this theta value into the normalized score of the second innings
% to predict the number of runs that the first team would have scored
% had it played exactly like the second team has so far. In other words,
% predict the first team's score given the second team's statistics. 
%
% If play is stopped and the second team is ahead of the predicted 
% score at this point, then it has outperformed what the first team 
% is predicted to have scored and is hence the winner. 
  predicted_score = abs(ceil(Xinput*theta_train));

  plot(1:m, Ysecond, 'g-', 'MarkerSize', 5, 'LineWidth', 2)
  
  hold on;

  plot(1:m, predicted_score, 'r-', 'MarkerSize', 5, 'LineWidth', 2)

  legend('Actual Score', 'Predicted Score', 'location', 'northwest')
  xlabel('Balls bowled (x)');
  ylabel('Runs scored (y)');
  title(text);

  print -deps -color 'second.eps'

  hold off;

  %fprintf('Program paused. Press enter to continue.\n');
  %pause;

  mu = mean(Ysecond - predicted_score);

  fprintf('Average difference from actual score %f\n', mu);

  fprintf('Trying Lambda: %f\n', lambda);

  %fprintf('Balls\t\tExtras\t\tRun Rate\tWickets\t\tScore\t\tPredicted\tDifference\n');
  fprintf('Balls   Wickets    Partnership 1stInn  2ndInn  Target  Diff\n');

%(X_norm, y(120)*ones(11,1),   X_pred_norm, Ysecond(120)*ones(11,1), Xpred, min_lambda);
%(Xfirst, Yfirst,              Xinput,           Ysecond,                 Xsecond,  lambda)

for i = 1:size(Xinput, 1)

  fprintf(' %d \t %d \t\t %d \t %d \t %d \t %d \t %d\n', ...
	  Xsecond(i, 1), 11 - (1 ./ Xsecond(i,4)), (1 ./ Xsecond(i,5)) \
	  - 1, Yfirst(i), Ysecond(i), predicted_score(i), Ysecond(i) - predicted_score(i));

  %fprintf(' %d     %d      %d       %d       %d       %d\n', ...
	%   Xsecond(i, 1), Xsecond(i,4), Yfirst(i), Ysecond(i), predicted_score(i), Ysecond(i) - predicted_score(i));

  endfor

% =========================================================================


end
