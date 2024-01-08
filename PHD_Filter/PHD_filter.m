load data_matlab.mat

% Given parameters for the filter
NB_STEPS = length(gt); % gt is a struct with two parameter : x and birth, 
% x gives us the number of present pedestrians
% NB_STEPS is the number of measurements (200 from gt (ground truth)
BOUND = 100;
% BOUND is the limit detection of the LIDAR (100 m ?)

% detection params
PD = 0.95;
lc = 4;

Q = diag([0.05, 0.05, 0.03, 0.05]);
R = diag([0.1^2, 4 * 0.017453^2]);

% Compute clutter intensity function
intensity_c = 2;

% time parameter
dt = 1; 
% considering the data from gt (ground truth), if we want to respect a 
% average pedestrian speed of 1.33 m/s, it seems that dt has to be at 1
% second

% survival parameter
PS = 0.9;
% if we considerer the lidar motionless, 0.9 seems to be a good first
% approximation

%{
 Birth weight
birth_weight = ...;
prune_threshold = ...; % choose a threshold, keep is low (< 1e-3)
nmax = ...;
%}
% Initialize state
states = struct([]);
ws = [];

dists = zeros(NB_STEPS, 1);
real_objs = [];

for step = 1:NB_STEPS
  % 1. Prediction step
  [ws, hyps] = PHD_predict(ws, gt{step,:}, dt, Q, PS);

  % 2. Correction step
  obs = all_obs{step};
  [ws, hyps] = PHD_update(ws, hyps, obs, R, PD, intensity_c);
  
  % 3. Mixture Reduction

  % Display debug information
  disp("step:"), disp(step);
  disp("n components:"), disp(length(ws));

  % 4. Extract estimates

  % 5. Metrics
  % Extract number of estimates
  ...

  % Compute GOSPA over number of targets in ground truth
  ...

  %%% Plot
  figure(1); clf; hold on;
  for i = 1:size(objs, 2)
      plot(objs(1, i), objs(2, i), 'b');
  end

  for i = 1:size(real_objs, 2)
      plot(real_objs(1, i), real_objs(2, i), 'o');
  end
  axis equal;
  xlim([-BOUND, BOUND]); ylim([-BOUND, BOUND]);
  hold off;
  pause(0.2);
  %%% End plot



  % 6. Birth of new components
  ...
  end

plot(dists);

