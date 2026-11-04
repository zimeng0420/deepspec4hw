module top_module (
	input d,
	input ena,
	output logic q
);

	always @(*) begin
		if (ena)
			q = d;
		// else q remains unchanged (latched value)
	end

endmodule