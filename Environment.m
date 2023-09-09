classdef Environment
    % Environment in Numerical Experiments.
    properties
        name string % Name of this Environemnt
        x0 double % Initial state the robot
        obstacles Obstacle % List of Obstacle
    end
    methods
        function obj = Environment(name, x0, obstalces)
            obj.name = name;
            obj.x0 = x0;
            obj.obstacles = obstalces;
        end
    end
end