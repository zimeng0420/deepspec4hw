module top_module(
    input mode,
    input too_cold, 
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    // Heater control: active in heating mode and when it's too cold
    assign heater = mode & too_cold;
    
    // Air conditioner control: active in cooling mode and when it's too hot
    assign aircon = ~mode & too_hot;
    
    // Fan control: active if heater or aircon is on, or if fan is manually turned on
    assign fan = heater | aircon | fan_on;

endmodule