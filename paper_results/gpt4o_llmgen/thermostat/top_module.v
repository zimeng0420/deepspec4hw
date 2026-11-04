module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater and air conditioner logic based on the mode and temperature conditions
    assign heater = mode & too_cold;
    assign aircon = ~mode & too_hot;
    
    // Fan logic to consider heater/aircon status and manual fan override
    assign fan = (heater | aircon) | fan_on;

endmodule