module top_module(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    assign heater = mode & too_cold;            // Heater on when mode is heating and too cold
    assign aircon = ~mode & too_hot;            // Aircon on when mode is cooling and too hot
    assign fan = fan_on | heater | aircon;      // Fan on if requested by user, or if heater or aircon is on

endmodule