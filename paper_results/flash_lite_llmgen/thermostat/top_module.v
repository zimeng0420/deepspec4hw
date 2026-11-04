module top_module(
	input mode,
	input too_cold,
	input too_hot,
	input fan_on,
	output reg heater,
	output reg aircon,
	output reg fan
);

  always @(*) begin
    // Fan control has the highest priority
    if (fan_on) begin
      fan = 1;
    end else begin
      fan = 0; // Default fan off
    end

    // Heating/Cooling logic
    if (mode) begin // Heating mode
      heater = too_cold;
      aircon = 0;
    end else begin // Cooling mode
      heater = 0;
      aircon = too_hot;
    end

    // Turn on fan if heater or aircon is on
    if (heater || aircon) begin
      fan = 1;
    end
  end

endmodule