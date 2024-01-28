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

  numberOfHyps = length(ws);

  for kHyp=1:numberOfHyps
      % EKF for each hypothesis
      hyp = EKF_predict(hyps(kHyp), dt, Q);
      % we have to take into account that a pedestrian can survive or not
      % (disappear from the sensor range). This is done by PS
      ws(kHyp+numberOfHyps) = ws(kHyp) + log(PS);
      hyps(kHyp+numberOfHyps) = hyp;
  end
end
