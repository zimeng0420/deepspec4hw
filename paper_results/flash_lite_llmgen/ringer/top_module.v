module top_module(
	input ring, 
	input vibrate_mode,
	output ringer,
	output motor
);

	// Internal signals
	wire ring_internal;
	wire vibrate_mode_internal;

	// Assign inputs to internal wires (for clarity and potential future modifications)
	assign ring_internal = ring;
	assign vibrate_mode_internal = vibrate_mode;

	// Logic for ringer and motor control
	always @(*) begin
		if (ring_internal) begin
			if (vibrate_mode_internal) begin
				motor = 1'b1;
				ringer = 1'b0;
			end else begin
				ringer = 1'b1;
				motor = 1'b0;
			end
		end else begin
			ringer = 1'b0;
			motor = 1'b0;
		end
	end

endmodule