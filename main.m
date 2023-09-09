clear

%% Create Environments
SAFETY_MARGIN = 0.5;

environment_A = Environment("A",[-5. -5. 0. 0.]',[ ...
    Obstacle("vase",-1.,-3.,SAFETY_MARGIN)
    Obstacle("toy",-3.,-1.,SAFETY_MARGIN)
]);
environment_B = Environment("B",[0. -10. 0. 0.]',[ ...
    Obstacle("vase",-1.,-4.,SAFETY_MARGIN)
    Obstacle("toy",1.5,-3.,SAFETY_MARGIN)
    Obstacle("vase",-1.,-2.,SAFETY_MARGIN)
]);

%% Select Environment

% !! STOP !!
% PLEASE EXECUTE COMMAND TO CREATE VARIABLE `environment`

% When you want to use the environment A, execute
% >> environment = environment_A
% When you want to use the environment B, execute
% >> environment = environment_B
% Or, you can create a new Environment.

%% Setup Plant & MPC Controller
DELTAT = 0.2;
maxsteps = 50;

A = [1 0 DELTAT 0;
    0 1 0 DELTAT;
    0 0 1 0;
    0 0 0 1];
B = [0 0;
     0 0;
     DELTAT 0;
     0 DELTAT];

Q = diag([1,1,1,1]);
R = diag([1,1]);
P = diag([100,100,100,100]);

NP = 8; % prediction horizon

umin = [-1.;-1.];
umax = [1.;1.];

%% Setup ChatMPC
theta0 = [0.4;0.4] % the adjustable parameter
d = [2;2]; % update constant: constant vector that specifies the increase/decrease of the parameter

%% Trial 1 (tau=0)
spec1 = Spec(A,B,Q,R,P,NP,environment,theta0,umin,umax);
[X1,U1] = run_mpc(spec1,A,B,maxsteps,Verbose=true);

%% Draw Trajectory of Trial 1
figure; hold on;
md = MapDrawer;
md.obstacles(environment);
md = md.trajectory(X1,Color="red",DisplayName="Trial 1");
md.finish(environment);
hold off;

%% Trial 1 -> Trial 2

% !! STOP !!
% TO USE the Interpreter,
% YOU NEED TO LAUNCH THE IntentExtractor PYTHON SERVER.

p1 = "Separate from the vase.";
theta1 = Interpreter(p1,theta0,d)

%% Trial 2 (tau=1)
spec2 = Spec(A,B,Q,R,P,NP,environment,theta1,umin,umax);
[X2,U2] = run_mpc(spec2,A,B,maxsteps,Verbose=true);

%% Draw Trajectory of Trial 1 and Trial 2
figure; hold on;
md = MapDrawer;
md.obstacles(environment);
md = md.trajectory(X1,Color="red",DisplayName="Trial 1");
md = md.trajectory(X2,Color="blue",DisplayName="Trial 2");
md.finish(environment);
hold off;

%% Trial 2 -> Trial 3
p2 = "You don't have to be so careful about the toy.";
theta2 = Interpreter(p2,theta1,d)

%% Trial 3 (tau=2)
spec3 = Spec(A,B,Q,R,P,NP,environment,theta2,umin,umax);
[X3,U3] = run_mpc(spec3,A,B,maxsteps,Verbose=true);

%% Draw Trajectory of Trial 1, Trial 2 and Trial 3
figure; hold on;
md = MapDrawer;
md.obstacles(environment);
md = md.trajectory(X1,Color="red",DisplayName="Trial 1");
md = md.trajectory(X2,Color="blue",DisplayName="Trial 2");
md = md.trajectory(X3,Color="green",DisplayName="Trial 3");
md.finish(environment);
hold off;