function [ws, hyps] = PHD_update(ws, hyps, obs, R, PD, intensity_c)
  %%% Update the hypsotheses of the filter with the given observations
  %% - ws the log weights of the hypsotheses in the filter
  %% - hyps the hypsotheses in the filter, struct array with fields x and P
  %% - obs the matrix of observations at the current timestep, with size (meas_size, nb_meas)
  %% - R the given observation covariance matrix of size (meas_size, meas_size)
  %% - PD the probability of detecting an existing object (scalar constant)
  %% - intensity_c the clutter intensity (scalar constant)
  %%
  %%% Returns the updated log weights and hypsotheses

  if length(hyps) == 0 || size(obs, 2) == 0
    return;
  end

  numberOfhyps = length(hyps);
  % first update step
  for khyp=1:numberOfhyps
      hyps(khyp).ws = log(1-PD)+hyps(khyp).ws;
  end

  % second update step
  for khyp=1:numberOfhyps
      % Use dark magic to split array into variables
      [x, y, theta, v] = feval(@(x)x{:}, num2cell(hyps(khyp).x));
      H = [x/sqrt(x^2+y^2),y/sqrt(x^2+y^2),0,0;-y/(x^2+x*y),1/(x+y),0,0];
      hyps(khyp).z_hat = H*[x, y, theta, v]';
      S = R + H*hyps(khyp).P*H';
      hyps(khyp).K = hyps(khyp).P*H'*inv(S);
      hyps(khyp).P = (eye(2)-K*H)*hyps(khyp).P;
  end

  % third update step
  m_k = length(obs);
  for i=1:m_k
      for khyp=1:numberOfhyps
          % Use dark magic to split array into variables
          [x, y, theta, v] = feval(@(x)x{:}, num2cell(hyps(khyp).x));
          X = [x, y, theta, v]';
          X = X+hyps(khyp).K*(z-hyps(khyp).z_hat);
          ws = ws + log(PD) + log();

          hyps(khyp).x = X(1);
          hyps(khyp).y = X(2);
          hyps(khyp).theta = X(3);
          hyps(khyp).v = X(4);
      end
      % normalization
      for khyp=1:numberOfhyps
          ws = logsumexp((log(intensity_c),));
      end
  end

end
