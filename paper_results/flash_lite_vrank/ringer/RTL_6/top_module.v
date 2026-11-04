module top_module(
	input ring, 
	input vibrate_mode,
	output ringer,
	output motor
);

    always @(*) begin
        if (vibrate_mode) begin
            motor = ring;
            ringer = 1'b0;
        end
        else begin
            motor = 1'b0;
            ringer = ring;
        end
    end

endmodule