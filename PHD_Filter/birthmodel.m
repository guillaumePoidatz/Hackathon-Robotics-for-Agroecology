function [ws, hyps] = birthmodel(obs, birth_weight, R)
  %%%% Outputs hypotheses and their weights, using:
  %% - obs the matrix of observations of size (measurement_dim, nb_measurements)
  %% - birth_weight a parameter of the filter: the constant birth weight to give to all new hypotheses (in log domain)
  %% - R the measurement noise matrix of size (measurement_dim, measurement_dim)
  %%% Outputs:
  %% - ws the log weights of the newborn hypotheses, of size (nb_new_hyps, 1)
  %% - hyps a struct array of size (1, nb_new_hyps) with fields:
  %%   - x the state vector of the hypotesis
  %%   - P the corresponding covariance matrix

  % Number of observations
  mk = size(obs, 2);

  % Empty struct to add the hypotheses to
  hyps = struct([]);

  % For each measurement
  for i = 1:mk
    hyp = struct;
    hyp.x = ...

    hyp.P = ...;

    hyps = [hyps, hyp];
  endfor

  ws = ...;
endfunction
