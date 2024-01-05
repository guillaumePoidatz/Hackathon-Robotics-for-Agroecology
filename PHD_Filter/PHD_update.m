function [ws, hyps] = PHD_update(ws, hyps, obs, R, PD, intensity_c)
  %%% Update the hypotheses of the filter with the given observations
  %% - ws the log weights of the hypotheses in the filter
  %% - hyps the hypotheses in the filter, struct array with fields x and P
  %% - obs the matrix of observations at the current timestep, with size (meas_size, nb_meas)
  %% - R the given observation covariance matrix of size (meas_size, meas_size)
  %% - PD the probability of detecting an existing object (scalar constant)
  %% - intensity_c the clutter intensity (scalar constant)
  %%
  %%% Returns the updated log weights and hypotheses

  if length(hyps) == 0 || size(obs, 2) == 0
    return;
  end

  ws = ws + log(PD) + log;

end
