function hyp = EKF_predict(hyp, dt, Q)
  %%% Extended Kalman Filter prediction
  %% - hyp the hypothesis to predic, struct with fields:
  %%   - x the state vector associated to the hypothesis of size (state_size, 1)
  %%   - P the associated covariance matrix
  %% - dt the time interval for the prediction
  %% - Q the process noise covariance matrix of size (state_size, state_size)
  %%
  %%% Returns
  %% - hyp of the same type and shape as the input hyp

  print(hyp)

  % Use dark magic to split array into variables
  [x, y, theta, v] = feval(@(x)x{:}, num2cell(hyp.x));

  % this matrix and how it is obtained is explained inside the report
  F = [1,0,- v*sin(theta)*dt,v*cos(theta)*dt;...
      0,1,v*cos(theta)*dt,v*sin(theta)*dt;...
      0,0,1,0;0,0,0,1];

  % Predict the state
  X = F*[x, y, theta, v]';
  hyp.x = X(1);
  hyp.y = X(2);
  hyp.theta = X(3);
  hyp.v = X(4);

  % Predict the covariance
  hyp.P = F*hyp.P*F'+Q; % cov matrix of the prediction (Pk|k-1)
end
