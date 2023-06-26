function inqconfun_sum = get_inqconfun_sum(u_s)
global X0 DELTAT
[x_history, stagecost_history] = simulate_steps(X0,u_s);
N = length(u_s);
inqconfun_sum = 0.0;
for i=1:N
    x = x_history(:,i);
    u = u_s(:,i);
    inqconfun = get_inqconfun(x,u);
    inqconfun_sum = inqconfun_sum + inqconfun;
end
end

