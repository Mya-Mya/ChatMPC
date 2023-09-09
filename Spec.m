classdef Spec
    % Specification of the MPC Controller
    % The methods `objective` and `nonlcon` are useful for fmincon.
    properties
        A double
        B double

        Q double
        R double
        P double
        pred_horizon int8

        environment Environment
        adjustable_parameter double

        Umin double
        Umax double

        U0 double
        
        num_obstacles
        gamma_minus_1_s
    end
    
    methods
        function obj = Spec( ...
                A,B, ...
                Q,R,P, ...
                pred_horizon, ...
                environment, adjustable_parameter, ...
                umin, umax...
        )
            obj.A = A; obj.B = B;
            obj.Q = Q; obj.R = R; obj.P = P;
            obj.pred_horizon = pred_horizon;

            obj.environment = environment;
            obj.adjustable_parameter = adjustable_parameter;

            obj.Umin = repelem(umin,1,pred_horizon);
            obj.Umax = repelem(umax,1,pred_horizon);

            obj.U0 = zeros([2,obj.pred_horizon]);

            obj.num_obstacles = length(environment.obstacles);

            OBSTALETYPE_TO_APINDEX = dictionary("vase",1,"toy",2);
            obj.gamma_minus_1_s = []; % gamma_minus_1_s(j) = (gamma of Obstacle j) - 1
            for obstacle_index = 1:obj.num_obstacles
                obstacle = obj.environment.obstacles(obstacle_index);
                type = obstacle.type;
                gamma = adjustable_parameter(OBSTALETYPE_TO_APINDEX(type));
                gamma_minus_1 = gamma - 1.;
                obj.gamma_minus_1_s = [obj.gamma_minus_1_s; gamma_minus_1];
            end
        end
        
        function J = objective(obj,x_current,U)
            J = 0.0;
            x = x_current;
            for i=1:obj.pred_horizon
                u = U(:,i);
                x = obj.step(x,u);
                J = J + x'*obj.Q*x + u'*obj.R*u;
            end
            J = J + x'*obj.P*x;
        end

        function x_next = step(obj,x,u)
            x_next = obj.A*x+obj.B*u;
        end

        function [c,ceq] = nonlcon(obj,x_current,U)
            c = 0.0;
            ceq = 0.0;
            x = x_current;

            h_s = zeros([obj.num_obstacles,1]);

            for i=1:obj.pred_horizon
                h_s_prev = h_s;

                pos = x(1:2);

                for obstacle_index=1:obj.num_obstacles
                    obstacle = obj.environment.obstacles(obstacle_index);
                    h = squared(pos - obstacle.pos) - obstacle.safety_margin2;
                    h_s(obstacle_index) = h;
                end

                if i>=2
                    % CBF Constraints : b = h+(γ-1)h_prev >= 0
                    for obstacle_index=1:obj.num_obstacles
                        gamma_minus_1 = obj.gamma_minus_1_s(obstacle_index);
                        b = h_s(obstacle_index)+gamma_minus_1*h_s_prev(obstacle_index);
                        c = c+max(0,-b);
                    end
                end
                u = U(:,i);
                x = obj.step(x,u);
            end
        end
    end
end

