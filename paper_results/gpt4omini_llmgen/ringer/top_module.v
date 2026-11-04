module top_module(
    input ring, 
    input vibrate_mode,
    output ringer,
    output motor
);

    // Internal signals to manage the outputs
    assign ringer = ring & ~vibrate_mode; // Ringer is ON if ring is high and vibrate_mode is LOW
    assign motor = ring & vibrate_mode;    // Motor is ON if ring is high and vibrate_mode is HIGH

endmodule