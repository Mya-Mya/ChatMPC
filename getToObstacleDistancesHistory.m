function D = getToObstacleDistancesHistory(obstacles,X)
arguments
    obstacles Obstacle % List of Obstacle
    X double
end
n_obstacles = length(obstacles);
position_s = X(1:2,:);
k_max = length(position_s);

D = zeros(n_obstacles, k_max);
for obstacle_idx = 1:n_obstacles
    obstacle = obstacles(obstacle_idx);
    o_pos = obstacle.pos;
    safety_margin = obstacle.safety_margin;
    for k = 1:k_max
        pos = position_s(:,k);
        d = norm(pos-o_pos) - safety_margin;
        D(obstacle_idx, k) = d;
    end
end

end