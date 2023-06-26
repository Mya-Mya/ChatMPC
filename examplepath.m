tic

u_s = [
    ones(1,HORIZON)
    zeros(1,HORIZON)
];
[x_history,stagecost_history] = simulate_steps(X0,u_s);
inqconfun_history = zeros(HORIZON,1);
for k=k_s
    inqconfun_history(k) = get_inqconfun(x_history(:,k),u_s(:,k));
end

toc
%%
figure

subplot 211;hold on;title Map
draw_map
plot(x_history(1,:),x_history(2,:),LineStyle="none",Marker=".")
legend

hold off;subplot 212;hold on;title Costs
xlabel Time

yyaxis left
plot(t_s,stagecost_history,DisplayName="Stagecost")
ylabel Stagecost;title Stagecost
yyaxis right
plot(t_s,inqconfun_history,DisplayName="Inqconfun")
ylabel Inqconfun;title Inqconfun
legend

hold off
