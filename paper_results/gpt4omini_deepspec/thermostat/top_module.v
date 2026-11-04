module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    assign heater = mode & too_cold; // Heater is on in heating mode when it is too cold
    assign aircon = ~mode & too_hot;  // Air conditioner is on in cooling mode when it is too hot
    assign fan = heater | aircon | fan_on; // Fan is on if heater or aircon is on, or if fan_on is requested

endmodule