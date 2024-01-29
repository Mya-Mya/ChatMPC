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

disp("!! STOP !!")
disp("PLEASE EXECUTE COMMAND TO CREATE VARIABLE `environment`")

disp("When you want to use the environment A, execute")
disp(">> environment = environment_A")
disp("When you want to use the environment B, execute")
disp(">> environment = environment_B")
disp("Or, you can set a new Environment.")

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
D1 = getToObstacleDistancesHistory(environment.obstacles, X1);

%% Draw Trajectory of Trial 1
figure; hold on;
md = MapDrawer;
md.obstacles(environment);
md = md.trajectory(X1,Color="blue",DisplayName="Trial 1");
md.finish(environment);
hold off;

%% Trial 1 -> Trial 2

% !! STOP !!
% TO USE the Interpreter,
% YOU NEED TO LAUNCH THE IntentExtractor PYTHON SERVER.

p1 = "Separate from the vase.";
theta1 = Interpreter(p1,theta0,d)
% theta1 should be [0.2; 0.4].

%% Trial 2 (tau=1)
spec2 = Spec(A,B,Q,R,P,NP,environment,theta1,umin,umax);
[X2,U2] = run_mpc(spec2,A,B,maxsteps,Verbose=true);
D2 = getToObstacleDistancesHistory(environment.obstacles, X2);

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
% theta2 should be [0.2; 0.8].

%% Trial 3 (tau=2)
spec3 = Spec(A,B,Q,R,P,NP,environment,theta2,umin,umax);
[X3,U3] = run_mpc(spec3,A,B,maxsteps,Verbose=true);
D3 = getToObstacleDistancesHistory(environment.obstacles, X3);

%% Draw Trajectory of Trial 1, Trial 2 and Trial 3
figure; hold on;
md = MapDrawer;
md.obstacles(environment);
md = md.trajectory(X1,Color="blue",DisplayName="Trial 1");
md = md.trajectory(X2,Color="red",DisplayName="Trial 2");
md = md.trajectory(X3,Color="black",DisplayName="Trial 3");
md.finish(environment);
hold off;

%% Draw Trajectory of Trial 3
figure; hold on;
md = MapDrawer;
md.obstacles(environment);
md = md.trajectory(X3,Color="black",DisplayName="Trial 3");
md.finish(environment);
hold off;

%% Draw to-Obstacle Distances

n_obstacles = length(environment.obstacles);
fig = figure(Name="ToObstacleDistances."+environment.name);
for obstacle_idx = 1:n_obstacles
    obstacle = environment.obstacles(obstacle_idx);
    obstacle_type = obstacle.type;
    subplot(n_obstacles,1,obstacle_idx);
    title( ...
        "Distance to "+obstacle_type+" at $("+obstacle.x1+","+obstacle.x2+")$", ...
        Interpreter="latex");
    hold on;
    plot(D1(obstacle_idx,:), "b-o", DisplayName="Trial 1");
    plot(D2(obstacle_idx,:), "r-o", DisplayName="Trial 2");
    plot(D3(obstacle_idx,:), "k-o", DisplayName="Trial 3");
    ylim([0 inf]);
    xlabel("Time $k$", Interpreter="latex");
    ylabel("Distance", Interpreter="latex");
    legend(Location="southwest")
    hold off;
end
fontsize(fig, 14, "points");