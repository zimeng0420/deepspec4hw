module top_module(
    input ring, 
    input vibrate_mode,
    output ringer,
    output motor
);

    // Ringer logic: Activate when not in vibrate mode and ring is active
    assign ringer = ~vibrate_mode & ring;

    // Motor logic: Activate when in vibrate mode and ring is active
    assign motor = vibrate_mode & ring;

endmodule