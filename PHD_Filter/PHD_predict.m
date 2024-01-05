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
      ws = ws + log(PS);
      hyps(kHyp).x(1) = x + v*cos(theta)*dt;
      hyps(kHyp).x(2) = y + v*sin(theta)*dt;
      % theta and v are not modified because of the assumption of constant
      % speed and direction with high variance
      hyps(kHyp).P = F*hyps(kHyp).P*F'+Q;
  end
end
