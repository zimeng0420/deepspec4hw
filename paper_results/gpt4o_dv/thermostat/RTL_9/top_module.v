module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater control: active only in heating mode and when it is too cold
    assign heater = mode & too_cold;

    // Air conditioner control: active only in cooling mode and when it is too hot
    assign aircon = ~mode & too_hot;

    // Fan control: active if heater is on, aircon is on, or fan_on is requested
    assign fan = heater | aircon | fan_on;

endmodule