module top_module(
	input ring, 
	input vibrate_mode,
	output ringer,
	output motor
);

    // Motor activation logic
    assign motor = vibrate_mode & ring;

    // Ringer activation logic
    assign ringer = ~vibrate_mode & ring;

endmodule