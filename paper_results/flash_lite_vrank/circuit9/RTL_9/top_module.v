module top_module (
	input clk,
	input a, 
	output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'b100; // 4
    end else begin
        case (q)
            3'b100: q <= 3'b101; // 5
            3'b101: q <= 3'b110; // 6
            3'b110: q <= 3'b000; // 0
            3'b000: q <= 3'b001; // 1
            3'b001: q <= 3'b010; // 2 - this case is not necessary, but include for completeness
            3'b010: q <= 3'b011; // 3 - this case is not necessary, but include for completeness
            3'b011: q <= 3'b100; // 4 - this case is not necessary, but include for completeness
            default: q <= q; // Keep current value in default case. This prevents possible X values.
        endcase
    end
end

endmodule