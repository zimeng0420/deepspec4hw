module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    assign heater = mode & too_cold; // Heater control logic
    assign aircon = ~mode & too_hot;  // Air conditioner control logic
    assign fan = (heater | aircon) | fan_on; // Fan control logic

endmodule