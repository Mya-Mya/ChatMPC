classdef Obstacle
    properties
        type string
        x1 double
        x2 double
        safety_margin double
        pos (2,1)double
        safety_margin2 double
    end
    methods
        function obj = Obstacle(type,x1,x2,safety_margin)
            obj.type = type;
            obj.x1 = x1;
            obj.x2 = x2;
            obj.safety_margin = safety_margin;
            obj.pos = [obj.x1;obj.x2];
            obj.safety_margin2 = obj.safety_margin^2;
        end
    end
end

