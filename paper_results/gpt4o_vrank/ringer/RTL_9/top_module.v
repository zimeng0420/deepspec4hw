module top_module(
    input ring, 
    input vibrate_mode,
    output ringer,
    output motor
);

    // Use a conditional operator to determine which output to activate
    assign ringer = ring & ~vibrate_mode;
    assign motor = ring & vibrate_mode;

endmodule