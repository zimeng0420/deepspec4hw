module top_module(
	input ring, 
	input vibrate_mode,
	output ringer,
	output motor
);
    always @(*) begin
        if (vibrate_mode) begin
            motor = ring;
            ringer = 0;
        end
        else begin
            ringer = ring;
            motor = 0;
        end
    end
endmodule