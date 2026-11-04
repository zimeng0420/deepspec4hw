module top_module(
    // Input for the thermostat
    input mode,
    // Input for the temperature
    input too_cold,
    // Input for the temperature
    input too_hot,
    // Input to turn on the fan
    input fan_on,

    // Output for the heater
    output reg heater,
    // Output for the air conditioner
    output reg aircon,
    // Output for the fan
    output reg fan
);

    // Main logic
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