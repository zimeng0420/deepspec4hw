module top_module(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Ringer is active when there's a ring and not in vibrate mode
    assign ringer = ~vibrate_mode & ring;
    
    // Motor is active when there's a ring and in vibrate mode
    assign motor = vibrate_mode & ring;

endmodule