function [z_hat, H] = measmodel(hyp)
  %%% Returns the expected measurement ant the corresponding jacobian matrix
  %% - hyp is the hypothesis for which we want the observation model, as a struct with fields:
  %%   - x the state vector of size (state_size, 1)
  %%   - P the associated covariance matrix of size (state_size, state_size)
  %%
  %%% Returns
  %% - z_hat the expected measurement of size (measurement_size, 1)
  %% - H the associated Jacobian matrix of size (measurement_size, state_size)

  % the obseration model is detailed inside the report
  z_hat = [sqrt(hyp.x(1,1)^2+hyp.x(2,1)^2),atan2(hyp.x(2,1),hyp.x(1,1))];

  % H matrix (jacobian of the observation model)
  H = [hyp.x(1,1)/sqrt(hyp.x(1,1)^2+hyp.x(2,1)^2),hyp.x(2,1)/sqrt(hyp.x(1,1)^2+hyp.x(2,1)^2),0,0;...
      -hyp.x(2,1)/(hyp.x(1,1)^2+hyp.x(1,1)*hyp.x(2,1)),1/(hyp.x(1,1)+hyp.x(2,1)),0,0];
end
