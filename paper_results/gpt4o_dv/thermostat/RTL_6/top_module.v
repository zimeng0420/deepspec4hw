module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater control logic: Activate heater in heating mode when it's too cold.
    assign heater = mode & too_cold;

    // Air conditioner control logic: Activate aircon in cooling mode when it's too hot.
    assign aircon = ~mode & too_hot;

    // Fan control logic: Turn on the fan if either heater, aircon is on, or fan_on is manually activated.
    assign fan = heater | aircon | fan_on;

endmodule