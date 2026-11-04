module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);
    // Heater control: ON if mode is heating (1) and it is too cold
    assign heater = mode & too_cold;

    // Air conditioner control: ON if mode is cooling (0) and it is too hot
    assign aircon = ~mode & too_hot;

    // Fan control: ON if heater is ON, aircon is ON, or fan_on is asserted
    assign fan = heater | aircon | fan_on;
endmodule