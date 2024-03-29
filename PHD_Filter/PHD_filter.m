%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Work from Guillaume Poidatz and Runkun Luo - From the code of Rémy Huet
% 2024

clear all
close all
load data_matlab.mat
%load data_nonoise_matlab.mat

% Given parameters for the filter
NB_STEPS = length(gt); % gt is a struct with two parameter : x and birth, 
% NB_STEPS is the number of measurements (200 from gt (ground truth)
BOUND = 100;
% BOUND is the limit detection of the LIDAR (100 m -> determined by the 
% specifications of your sensor)

% detection params
PD = 0.95; % 0.999 in the subect, it is advice to use PD = 1 (PD is the 
% probability of an object to be detected). For the no noise case it should
% be obviously 1 but there are some numerical problem in the equation
% resulting in weights equal to nan. So, in practice for the no noise case,
% we set PD very high almost 1

lc = 4; %0; version without noise % expectation over the clutters
% generated by the sensors,

% noises covariance matrices respectively on the evolution model and
% observation model
Q = diag([0.05, 0.05, 0.03, 0.05]);
R = diag([0.1^2, 4 * 0.017453^2]); %diag([0.0001^2, 0.004 * 0.017453^2]); % ;version without noise

% Compute clutter intensity function
intensity_c =  lc/(BOUND)^2; 

% time parameter
dt = 1; 
% considering the data from gt (ground truth), if we want to respect a 
% average pedestrian speed of 1.33 m/s, it seems that dt has to be at 1
% second

% survival parameter
PS = 0.85;
% if we considerer the lidar motionless, 0.9 seems to be a good first
% approximation

%Birth weight
birth_weight = log(0.01);

prune_threshold = log(0.0001); % choose a threshold, keep is low (< 1e-3)
% this threshold is used to select which hypothesis we decide to cancel
% consesidering their weight (the confidence about the Gaussian
% representing indeed an object). To avoid exploring useless part of the
% space
merge_threshold = 1;
nmax =  100; %100 version without noise % this is the maximum number of particule
% this is with prune_threshold, the second parameter in order to reduce the
% number of hypothesis

% Initialize state
states = struct([]); % the structure containing pur hypothesis 
% (states : x,y,theta,v) and covariance matrix
ws = [];

% - Observations and objects real arrays
real_objs = [];
obs = [];

real_objs = [];
GOSPAvalue = zeros(1,NB_STEPS);
numberOfEstimates = zeros(1,NB_STEPS);
numberOfTrueObjs = zeros(1,NB_STEPS);


for step = 1:NB_STEPS
  % 1. Prediction step
  [ws, states] = PHD_predict(ws,states, 1, Q, PS);

  % 2. Correction step
  obs = all_obs{step};
  [ws, states] = PHD_update(ws, states, obs, R, PD,intensity_c);

  % 3. Mixture Reduction
  [ws, states] = ref.reduction(ws, states, prune_threshold,merge_threshold, nmax);

  % Display debug information
  disp("step:"), disp(step);
  disp("n components:"), disp(length(ws));

  % 4. Extract estimates
  % just for the plot
  objs = estimates(ws, states);

  % 5. Metrics
  % Extract number of estimates
  numberOfEstimates(step) = round(sum(exp(ws)));

  % Compute GOSPA over number of targets in ground truth
  % GOSPA means : "generalized optimal sub-pattern assignment"
  gtStep_array12 = [];
  for kGtStep = 1:length(gt{step})
      gtStep_array12(:,kGtStep) = gt{step}(kGtStep).x(1:2);
  end
  GOSPAvalue(step) = ref.GOSPA(objs,gtStep_array12,10);
  numberOfTrueObjs(step) = size(gt{step},2);
  GOSPAvalue(step) = GOSPAvalue(step)/numberOfTrueObjs(step);

  % 6. Birth of new components
  [wsb, statesb] = birthmodel(obs, birth_weight, R);
  ws = [ws,wsb];
  states = [states,statesb];

  % ---  Plot  ----------------------------------------- %

  figure(1); clf; hold on;

  %% - Estimate objects
  for i = 1:size(objs, 2)

    scatter(objs(1, i), objs(2, i),'o','LineWidth', 4);

  end

  %% - Real objects
  for i = 1:size(gt{step}, 2)
    scatter(gt{step}(i).x(1), gt{step}(i).x(2),'x','LineWidth', 3);
  end

  axis equal;
  xlim([-BOUND, BOUND]); ylim([-BOUND, BOUND]);
  hold off;
  pause(0.2);

  %%% End plot
  
end

% graph of number of target estimated vs true number of target
figure(2)
plot(1:NB_STEPS,numberOfEstimates,'b');
hold on
plot(1:NB_STEPS,numberOfTrueObjs,'r');
title("Number of pedestrians");
legend('estimated number of objects', 'ground truth');

% show the results of the GOSPA
figure(3);
plot(1:NB_STEPS,GOSPAvalue,'b');
title("GOSPA metric");
hold on
