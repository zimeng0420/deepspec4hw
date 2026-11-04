module top_module (
	input [7:0] in,
	output reg [2:0] pos
);

	always @(*) begin
		casez (in)
			8'bzzzzzzzz: pos = 3'b000; // All zeros
			8'bzzzzzzz1: pos = 3'b000; // Bit 0 is high
			8'bzzzzzz1z: pos = 3'b001; // Bit 1 is high
			8'bzzzzz1zz: pos = 3'b010; // Bit 2 is high
			8'bzzzz1zzz: pos = 3'b011; // Bit 3 is high
			8'bzzz1zzzz: pos = 3'b100; // Bit 4 is high
			8'bzz1zzzzz: pos = 3'b101; // Bit 5 is high
			8'bz1zzzzzz: pos = 3'b110; // Bit 6 is high
			8'b1zzzzzzz: pos = 3'b111; // Bit 7 is high
			default: pos = 3'b000; // Should not happen, but good practice
		endcase
	end

endmodule