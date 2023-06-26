figure; hold on; title Map
draw_map
plot(opt_x_history(1,:),opt_x_history(2,:), ...
    LineStyle="none",Marker="x",MarkerEdgeColor="black",MarkerFaceColor="black",DisplayName="Position")
legend
hold off;

figure;

subplot 311;hold on; title StagecostHistory
plot(t_s,opt_stagecost_history)
xlabel Time; ylabel Stagecost

hold off;subplot 312;hold on; title PositionHistory
plot(t_s,opt_x_history(1,:),DisplayName="x1")
plot(t_s,opt_x_history(2,:),DisplayName="x2")
yline(GOAL_X1,LineStyle=":",DisplayName="Goal x1")
legend
xlabel Time; ylabel Position

hold off;subplot 313;hold on;title InputHistory
plot(t_s,opt_u_s(1,:),DisplayName="Acceleration")
plot(t_s,opt_u_s(2,:),DisplayName="Steering")
yline(0,LineStyle=":")
legend
xlabel Time; ylabel Input
hold off
