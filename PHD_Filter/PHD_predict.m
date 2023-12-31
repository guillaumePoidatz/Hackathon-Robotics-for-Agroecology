function [ws, hyps] = PHD_predict(ws, hyps, dt, Q, PS)
  %%% Predict each hypothesis independently from others
  %% - ws the log weights of the hypotheses in the filter, with size (nb_hyps, 1)
  %% - hyps the hypotheses of the filter, a struct array of size nb_hyps with fields
  %%   - x the state vector of the hypothesis of size (state_size, 1)
  %%   - P the associated covariance matrix of size (state_size, state_size)
  %% - dt the time interval for the prediction
  %% - Q the process noise covariance matrix of size (state_size, state_size)
  %% - PS the probability of survival
  %%
  %%% Returns
  %% - ws the predicted log weights
  %% - hyps the predicted hypotheses

  numberOfHyps = length(hyps);
  for kHyp=1:numberOfHyps
      % Use dark magic to split array into variables
      [x, y, theta, v] = feval(@(x)x{:}, num2cell(hyps(kHyp).x));
      % this matrix and how it is obtained is explained inside the report
      F = [1,0,- v*sin(theta)*dt,v*cos(theta)*dt;...
      0,1,v*cos(theta)*dt,v*sin(theta)*dt;...
      0,0,1,0;0,0,0,1];

      hyps(kHyp).ws = hyps(kHyp).ws + log(PS);
      X = [x, y, theta, v]';
      X = F*X;
      hyps(kHyp).P = F*P*F'+Q;
      hyps(kHyp).x = X(1);
      hyps(kHyp).y = X(2);
      hyps(kHyp).theta = X(3);
      hyps(kHyp).v = X(4);
  end
end
