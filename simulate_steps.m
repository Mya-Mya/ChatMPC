function [x_history,stagecost_history] = simulate_steps(x,u_s)
global X_DIM
N = length(u_s);
x_history = zeros(X_DIM,N);
stagecost_history = zeros(N,1);
for k=1:N
    u = u_s(:,k);

    stagecost = get_stagecost(x,u);
    stagecost_history(k) = stagecost;
    
    x = step(x,u);
    x_history(:,k) = x;
end
end

