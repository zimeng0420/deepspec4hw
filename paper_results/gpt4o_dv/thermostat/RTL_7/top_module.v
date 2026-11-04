module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater Control Logic
    assign heater = mode & too_cold;

    // Air Conditioner Control Logic
    assign aircon = ~mode & too_hot;

    // Fan Control Logic
    assign fan = heater | aircon | fan_on;

endmodule