function [z_hat, H] = measmodel(hyp)
  %%% Returns the expected measurement ant the corresponding jacobian matrix
  %% - hyp is the hypothesis for which we want the observation model, as a struct with fields:
  %%   - x the state vector of size (state_size, 1)
  %%   - P the associated covariance matrix of size (state_size, state_size)
  %%
  %%% Returns
  %% - z_hat the expected measurement of size (measurement_size, 1)
  %% - H the associated Jacobian matrix of size (measurement_size, state_size)

  % Expected measurement
  % size of 2*1 (2 measurements)
  z_hat = [sqrt(hyp.x^2+hyp.y^2),atan2(hyp.y,hyp.x)];

  % H matrix (jacobian of the observation model)
  H = [hyp.x/sqrt(hyp.x^2+hyp.y^2),hyp.y/sqrt(hyp.x^2+hyp.y^2),0,0;...
      -hyp.y/(hyp.x^2+hyp.x*hyp.y),1/(hyp.x+hyp.y),0,0];
end
