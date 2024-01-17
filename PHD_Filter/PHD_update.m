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

  numberOfhyps = length(ws);
  % first update step
  for khyp=1:numberOfhyps
      ws(khyp) = log(1-PD)+ ws(khyp);
  end

  z_hat=[];
  S = cell(1,numberOfhyps);
  K = cell(1,numberOfhyps);
  % second update step
  for khyp=1:numberOfhyps
      [z_hat(:,khyp), H] = measmodel(hyps(khyp));
      S{khyp} = R + H*hyps(khyp).P*H';
      K{khyp} = hyps(khyp).P*H'*inv(S{khyp});
      hyps(khyp).P = (eye(4)-K{khyp}*H)*hyps(khyp).P;
  end

  % third update step
  m_k = size(obs,2);
  for i_obs=1:m_k
      for khyp=1:numberOfhyps
          % Use dark magic to split array into variables
          [x, y, theta, v] = feval(@(x)x{:}, num2cell(hyps(khyp).x));
          X = [x, y, theta, v]';
          
          innovation=ref.err(obs(:,i_obs),z_hat(:,khyp));
          X = X+K{khyp}*innovation;
          hyps(i_obs*numberOfhyps+khyp).x = [X(1);X(2);X(3);X(4)];
          
          ws(i_obs*numberOfhyps+khyp) = ws(khyp) + log(PD) + ref.logmvnpdf(obs(:,i_obs)',z_hat(:,khyp)',S{khyp}');
      end
      % normalization
      for khyp=1:numberOfhyps
          ws(i_obs*numberOfhyps+khyp) = ws(i_obs*numberOfhyps+khyp)-ref.logsumexp([log(intensity_c),ws(i_obs*numberOfhyps+1:i_obs*numberOfhyps+numberOfhyps)]);
      end
  end

  % Normalize weights (convert from log scale)
  % we have to cancel this line for the no noise case (the practice show
  % that but i don't know why)
  ws = exp(ws);
end
