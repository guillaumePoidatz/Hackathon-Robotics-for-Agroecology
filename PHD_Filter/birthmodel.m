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
  ws = [];

  % For each measurement
  for i = 1:mk
      % inversion of the observation model + some assumptions on theta and
      % v
      uncertainty_x = sqrt(R(1,1)^2*(1+tan(R(2,2))^2)^-1);
      uncertainty_y = abs(tan(obs(2,i))*uncertainty_x);
      if cos(obs(2,i))>0
          pos_x = sqrt(obs(1,i)^2*(1+tan(obs(2,i))^2)^-1);
      else
          pos_x = -sqrt(obs(1,i)^2*(1+tan(obs(2,i))^2)^-1);
      end

      % the birth model for theta is explained inside the reports
      hyps(i).x = [pos_x;tan(obs(2,i))*pos_x;pi()-obs(2,i);1.31];
      hyps(i).P = diag([uncertainty_x,uncertainty_y,pi()^2,1]); % no intercorrelation at the beginning (before update)
      % very high variances for velocity and pose of the pedestrian as
      % precised in the report. Vxx and Vyy are a first random estimation

      ws = [ws,birth_weight];
  end
end