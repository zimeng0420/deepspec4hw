module top_module(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    assign motor = vibrate_mode | (ring & ~vibrate_mode);
    assign ringer = ring & ~vibrate_mode;

endmodule