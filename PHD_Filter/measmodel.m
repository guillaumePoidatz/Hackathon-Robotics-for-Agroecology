function [z_hat, H] = measmodel(hyp)
  %%% Returns the expected measurement ant the corresponding jacobian matrix
  %% - hyp is the hypothesis for which we want the observation model, as a struct with fields:
  %%   - x the state vector of size (state_size, 1)
  %%   - P the associated covariance matrix of size (state_size, state_size)
  %%
  %%% Returns
  %% - z_hat the expected measurement of size (measurement_size, 1)
  %% - H the associated Jacobian matrix of size (measurement_size, state_size)

  % Use dark magic to split array into variables
  [x, y, theta, v] = feval(@(x)x{:}, num2cell(hyp.x));
  
  % H matrix (jacobian of the observation model)
  H = [x/sqrt(x^2+y^2),y/sqrt(x^2+y^2),0,0;...
      -y/(x^2+x*y),1/(x+y),0,0];

  % Expected measurement
  % size of 2*1 (2 measurements)
  z_hat = H*[x,y,theta,v]';

  % Jacobian Matrix
  H = ...
endfunction
