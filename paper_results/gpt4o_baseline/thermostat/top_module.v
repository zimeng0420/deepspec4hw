module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater is on only in heating mode when it's too cold
    assign heater = mode & too_cold;

    // Air conditioner is on only in cooling mode when it's too hot
    assign aircon = ~mode & too_hot;

    // Fan is on if either heater or air conditioner is on, or if explicitly requested
    assign fan = heater | aircon | fan_on;

endmodule