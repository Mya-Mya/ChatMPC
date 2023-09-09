function new_adjustable_parameter = Interpreter(...
    prompt,adjustable_parameter,update_constant)
arguments
    prompt string
    adjustable_parameter double
    update_constant double
end

update_marker = run_intent_extractor(prompt);
new_adjustable_parameter = ParameterUpdater(...
    update_marker,adjustable_parameter,update_constant);

end