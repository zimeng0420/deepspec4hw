module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater Control: Activate only in heating mode when it's too cold
    assign heater = mode & too_cold;

    // Air Conditioner Control: Activate only in cooling mode when it's too hot
    assign aircon = ~mode & too_hot;

    // Fan Control: Activate when heater or air conditioner are on, or fan_on is requested
    assign fan = heater | aircon | fan_on;

endmodule