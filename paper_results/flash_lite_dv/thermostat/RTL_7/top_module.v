module thermostat (
  input mode,
  input too_cold,
  input too_hot,
  input fan_on,
  output reg heater,
  output reg aircon,
  output reg fan
);

  always @(*) begin
    // Heating mode
    if (mode) begin
      heater = too_cold;
      aircon = 0;
    end
    // Cooling mode
    else begin
      heater = 0;
      aircon = too_hot;
    end

    fan = heater | aircon | fan_on;
  end
endmodule