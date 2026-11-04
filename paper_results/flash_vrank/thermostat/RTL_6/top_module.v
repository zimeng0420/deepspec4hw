module top_module(
    input mode,
    input too_cold,
    input too_hot,
    input fan_on,
    output heater,
    output aircon,
    output fan
);

    assign heater = mode & too_cold;  // Heater on in heating mode when too cold
    assign aircon = ~mode & too_hot;  // Air conditioner on in cooling mode when too hot
    assign fan = (heater | aircon | fan_on); // Fan on when heater or aircon is on, or when fan_on is asserted

endmodule