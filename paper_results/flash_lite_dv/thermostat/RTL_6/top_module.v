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
    // Heater control logic
    if (mode) begin
      heater = too_cold;
    end else begin
      heater = 0;
    end

    // Air conditioner control logic
    if (!mode) begin
      aircon = too_hot;
    end else begin
      aircon = 0;
    end

    // Fan control logic
    fan = heater | aircon | fan_on;
  end

endmodule