module top_module(
    input mode,        // Thermostat mode: 1 for heating, 0 for cooling
    input too_cold,    // Indicates if it's too cold (for heating mode)
    input too_hot,     // Indicates if it's too hot (for cooling mode)
    input fan_on,      // Request to turn on the fan
    output reg heater,  // Output signal to turn on the heater
    output reg aircon,  // Output signal to turn on the air conditioner
    output reg fan      // Output signal to turn on the fan
);

    always @(*) begin
        // Default states for outputs
        heater = 0;
        aircon = 0;
        fan = 0;

        // Logic for heater and fan control in heating mode
        if (mode == 1) begin
            if (too_cold) begin
                heater = 1; // Turn on heater if it's too cold
            end
            if (fan_on || heater) begin
                fan = 1;    // Turn on fan if requested or if heater is on
            end
        end
        // Logic for air conditioner and fan control in cooling mode
        else begin
            if (too_hot) begin
                aircon = 1; // Turn on air conditioner if it's too hot
            end
            if (fan_on || aircon) begin
                fan = 1;    // Turn on fan if requested or if air conditioner is on
            end
        end
    end

endmodule