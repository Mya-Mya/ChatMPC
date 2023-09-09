function [X,U] = run_mpc(spec,A,B,maxsteps,options)
arguments
    spec Spec
    A double
    B  double
    maxsteps double
    options.GoalThreshold double = 0.5
    options.Verbose logical = false
end
opt = optimoptions("fmincon", ...
    MaxIterations=300, ...
    HessianApproximation="lbfgs", ...
    Display="off" ...
);

environment = spec.environment;
x = environment.x0;
X = [x];
U = [];

for k=1:maxsteps
    [U_opt,fval] = fmincon( ...
        @(U)spec.objective(x,U),...
        spec.U0,...
        [],[],[],[],...
        spec.Umin,spec.Umax,...
        @(U)spec.nonlcon(x,U),...
        opt ...
    );
    u = U_opt(:,1);
    x = A*x+B*u;

    X = [X x];
    U = [U u];

    distance_to_goal = norm(x);
    if options.Verbose
        disp([k,distance_to_goal])
    end
    if distance_to_goal<options.GoalThreshold
        break
    end
end

end