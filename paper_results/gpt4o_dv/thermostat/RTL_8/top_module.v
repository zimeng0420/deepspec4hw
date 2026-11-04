module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater control: Activate heater only in heating mode when too_cold
    assign heater = mode & too_cold;

    // Air conditioner control: Activate aircon only in cooling mode when too_hot
    assign aircon = ~mode & too_hot;

    // Fan control: Activate fan when either heater, aircon, or fan_on is active
    assign fan = heater | aircon | fan_on;

endmodule