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
    // Default to off
    heater = 0;
    aircon = 0;
    fan = 0;

    // Fan control
    if (fan_on) begin
        fan = 1;
    end else begin
        // Mode control
        if (mode) begin // Heating mode
            if (too_cold) begin
                heater = 1;
                fan = 1; // Fan on when heater is on
            end
        end else begin // Cooling mode
            if (too_hot) begin
                aircon = 1;
                fan = 1; // Fan on when air conditioner is on
            end
        end
    end
end

endmodule