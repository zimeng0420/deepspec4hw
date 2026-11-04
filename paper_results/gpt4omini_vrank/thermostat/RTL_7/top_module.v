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
    if (fan_on) begin
        fan = 1;
        heater = 0;
        aircon = 0;
    end else if (mode) begin // Heating mode
        fan = too_cold; // Fan on if heater is on
        heater = too_cold;
        aircon = 0;
    end else begin // Cooling mode
        fan = too_hot; // Fan on if aircon is on
        heater = 0;
        aircon = too_hot;
    end
end

endmodule