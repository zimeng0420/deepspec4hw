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
    end else if (mode) begin // heating mode
        heater = too_cold;
        aircon = 0;
        fan = heater; // fan on if heater is on
    end else begin // cooling mode
        aircon = too_hot;
        heater = 0;
        fan = aircon; // fan on if air conditioner is on
    end
end

endmodule