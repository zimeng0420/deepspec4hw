module top_module(
    input ring, 
    input vibrate_mode,
    output ringer,
    output motor
);

assign ringer = ring & ~vibrate_mode; // ringer is on when ring is 1 and vibrate_mode is 0
assign motor = ring & vibrate_mode; // motor is on when ring is 1 and vibrate_mode is 1

endmodule