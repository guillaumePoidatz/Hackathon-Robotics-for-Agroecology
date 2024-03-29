function [ws, hyps] = PHD_update(ws, hyps, obs, R, PD, intensity_c)
  %%% Update the hypsotheses of the filter with the given observations
  %% - ws the log weights of the hypsotheses in the filter
  %% - hyps the hypsotheses in the filter, struct array with fields x and P
  %% - obs the matrix of observations at the current timestep, with size (meas_size, nb_meas)
  %% - R the given observation covariance matrix of size (meas_size, meas_size)
  %% - PD the probability of detecting an existing object (scalar constant)
  %% - intensity_c the clutter intensity (scalar constant)
  %%
  %%% Returns the updated log weights and hypotheses

  if size(hyps, 2) == 0 || size(obs, 2) == 0
    return;
  end

  numberOfhyps = length(ws);
  % first update step
  % compute the miss detection hypothesis for each initial hypothesis
  ws_init = ws;
  for khyp=1:numberOfhyps
      ws(khyp) = log(1-PD)+ ws(khyp);
  end

  % second update step
  % pre-compute some values that only depend on the hypotheses and not on the measurements.
  z_hat = zeros(2, numberOfhyps);
  % cell type make the code more readable and is more powerful than array
  S = cell(1,numberOfhyps);
  K = cell(1,numberOfhyps);

  for khyp=1:numberOfhyps
      [z_hat(:,khyp), H] = measmodel(hyps(khyp));
      S{khyp} = R + H*hyps(khyp).P*H'; % innovation matrix
      K{khyp} = hyps(khyp).P*H'*inv(S{khyp});
      hyps(khyp).P = (eye(4)-K{khyp}*H)*hyps(khyp).P;
  end

  % third update step
  % observation and hypothesis association
  m_k = size(obs,2);
  for i_obs=1:m_k
      for khyp=1:numberOfhyps
          index = i_obs*numberOfhyps+khyp;
          innovation=ref.err(obs(:,i_obs),z_hat(:,khyp));
          hyps(index).x = hyps(khyp).x+K{khyp}*innovation;
          hyps(index).P = hyps(khyp).P;
          
          % we now compute the likelihood between the observation and the
          % hypothesis and update the weights (confidence  in an
          % hypothesis) with this likelihood, the probability of being a
          % miss detection and the probability of detection of an object 
          % (confidence inside the sensor thus the obs being a real object).
          % The weight is now at the index i_obs*numberOfhyps+khyp being 
          % the weight about the confidence inside that i_obs observation 
          % corresponds to the khyp hypothesis.
          likelihood = ref.logmvnpdf(obs(:,i_obs)',z_hat(:,khyp)',S{khyp});
          ws(i_obs*numberOfhyps+khyp) = ws_init(khyp) + log(PD) + likelihood ;
      end
      % normalization
      % This ensures that the sum of the weights generated by one 
      % measurement no more than 1. The clutter intensity at the point of 
      % the measurement is used to decrease the sum of the weights
      logsumexp = ref.logsumexp([log(intensity_c),ws(i_obs*numberOfhyps+1:index)]);
      for khyp=1:numberOfhyps
          index = i_obs*numberOfhyps+khyp;
          ws(index) = ws(index)-logsumexp;
      end
  end
end
