```verilog
module top_module(
	input [3:1] y,
	input w,
	output reg Y2);

	// States Encoding
	parameter A = 3'b000;
	parameter B = 3'b001;
	parameter C = 3'b010;
	parameter D = 3'b011;
	parameter E = 3'b100;
	parameter F = 3'b101;

	// Next-State Logic for y[2]
	always @(*) begin
		case (y)
			A: Y2 = 0;               // State A: y[2] = 0
			B: Y2 = (w) ? 1 : 0;     // State B: transition to D (1) or C (0)
			C: Y2 = (w) ? 1 : 1;     // State C: transition to D (1)
			D: Y2 = 1;               // State D: y[2] = 1
			E: Y2 = 1;               // State E: y[2] = 1
			F: Y2 = (w) ? 1 : 0;     // State F: transition to D (1) or C (0)
			default: Y2 = 0;         // Default case
		endcase
	end

endmodule
```