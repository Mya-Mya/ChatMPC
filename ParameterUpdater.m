function new_adjustable_parameter = ParameterUpdater(...
    update_marker,adjustable_parameter,update_constant)
arguments
    update_marker double
    adjustable_parameter double
    update_constant double
end
new_adjustable_parameter = ...
    (update_constant.^update_marker).*adjustable_parameter;
end