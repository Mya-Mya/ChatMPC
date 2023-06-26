function totalcost = get_totalcost(u_s)
global X0 DELTAT
[x_history, stagecost_history] = simulate_steps(X0,u_s);
N = length(x_history);
finalcost = get_finalcost(x_history(:,N),u_s(:,N));
totalcost = sum(stagecost_history)*DELTAT+finalcost;
end

