tic

initial_u_s = zeros(U_DIM, HORIZON);
[opt_u_s,fval] = fmincon( ...
    @(u_s)get_totalcost(u_s),...
    initial_u_s,...
    [],[],...% Linear Nonequal Constraints : A,b
    [],[],...% Linear Equal Constraints : Aeq,beq
    [],[],...% Lower/Upper Boundary
    @(u_s)get_confun_sums(u_s),...
    optimoptions("fmincon",...
        MaxFunctionEvaluations=30000 ...
    )...
);

[opt_x_history, opt_stagecost_history] = simulate_steps(X0,opt_u_s);

toc


record = struct("u_s",opt_u_s,"x_history",opt_x_history,"mpcparameter",mpcparameter)