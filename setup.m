%% Constants
global X0;X0 = [0; 0; 0; 0]
global DELTAT;DELTAT = 0.2
global HORIZON;HORIZON = 50
global GOAL_X1;GOAL_X1 = 10;
global GOAL_X2;GOAL_X2 = 0;

k_s = 1:HORIZON;
t_s = k_s*DELTAT;

% [x1 x2 v θ]
global X_DIM;X_DIM = length(X0)
% [a ω]
global U_DIM;U_DIM = 2
%% Obstacles
global LEFT_X1; LEFT_X1 = 3;
global LEFT_X2; LEFT_X2 = 1.2;
global RIGHT_X1; RIGHT_X1 = 7;
global RIGHT_X2; RIGHT_X2 = -1.2;

%% MPC Parameter
global mpcparameter;
mpcparameter = MPCParameter;
mpcparameter.r_right = 1.5;
mpcparameter.r_left = 1.5;