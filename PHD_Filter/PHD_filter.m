clear all
close all
load data_matlab.mat

% Given parameters for the filter
NB_STEPS = length(gt); % gt is a struct with two parameter : x and birth, 
% x gives us the number of present pedestrians
% NB_STEPS is the number of measurements (200 from gt (ground truth)
BOUND = 100;
% BOUND is the limit detection of the LIDAR (100 m ?)

% detection params
PD = 0.95;%1 version without noise
lc = 4;

Q = diag([0.05, 0.05, 0.03, 0.05]);
R = diag([0.1^2, 4 * 0.017453^2]); %diag([0.000001^2, 0.00004 * 0.017453^2]); version without noise

% Compute clutter intensity function
intensity_c = 2; % 0; version without noise

% time parameter
dt = 1; 
% considering the data from gt (ground truth), if we want to respect a 
% average pedestrian speed of 1.33 m/s, it seems that dt has to be at 1
% second

% survival parameter
PS = 0.9;
% if we considerer the lidar motionless, 0.9 seems to be a good first
% approximation

%Birth weight
birth_weight = 0.1;
prune_threshold = 5e-4; % choose a threshold, keep is low (< 1e-3)
nmax = 500; % 100; version without noise

% Initialize state
states = struct([]);
ws = [];

dists = zeros(NB_STEPS, 1);
real_objs = [];

for step = 1:NB_STEPS
  % 1. Prediction step
  [ws, states] = PHD_predict(ws,states, dt, Q, PS);

  % 2. Correction step
  obs = all_obs{step};
  [ws, states] = PHD_update(ws, states, obs, R, PD, intensity_c);

  % 3. Mixture Reduction
  [ws, states] = ref.reduction(ws, states, prune_threshold, nmax);

  % Display debug information
  disp("step:"), disp(step);
  disp("n components:"), disp(length(ws));

  % 4. Extract estimates
  objs = estimates(ws, states);

  % 5. Metrics
  % Extract number of estimates
  ...

  % Compute GOSPA over number of targets in ground truth
  % GOSPA means : "generalized optimal sub-pattern assignment"
  gtStep_array12 = [];
  for kGtStep = 1:length(gt{step})
      gt_array12(:,kGtStep) = gt{step}(kGtStep).x(1:2);
  end
  
  value = ref.GOSPA(objs,gtStep_array12,2);

  %%% Plot
  figure(1); clf;
  for i = 1:size(objs, 2)
      scatter(objs(1, i), objs(2, i), 'b','LineWidth', 4);
      hold on
  end

  for i = 1:size(gt{step}, 2)
      real_objs = gt{step}(i).x;
      scatter(real_objs(1), real_objs(2), 'x','LineWidth', 3);
  end

  xlim([-BOUND, BOUND]); 
  ylim([-BOUND, BOUND]);
  hold off;
  pause(0.2);

  % graph of number of target estimated vs true number of targer 
  figure(2)
  scatter(step, size(objs,2), 10,'b','filled');
  hold on
  scatter(step,size(gt{step}, 2),10,'r','filled');

  %%% End plot

  % 6. Birth of new components
  [ws, states] = birthmodel(obs, birth_weight, R);
  
end
