module top_module(
	input [3:1] y,
	input w,
	output reg Y2);

	// Define state codes (for readability and maintainability)
	localparam A = 3'b000;
	localparam B = 3'b001;
	localparam C = 3'b010;
	localparam D = 3'b011;
	localparam E = 3'b100;
	localparam F = 3'b101;

	// Next-state logic for y[2] (Y2)
	always @(*) begin
		case (y[3:1])
			A: begin // State A
				Y2 = 1'b0; // A --0--> B (001), A --1--> A (000)
			end
			B: begin // State B
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0; // B --0--> C (010), B --1--> D (011)
			end
			C: begin // State C
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0; // C --0--> E (100), C --1--> D (011)
			end
			D: begin // State D
				Y2 = (w == 1'b1) ? 1'b0 : 1'b0; // D --0--> F (101), D --1--> A (000)
			end
			E: begin // State E
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0; // E --0--> E (100), E --1--> D (011)
			end
			F: begin // State F
				Y2 = (w == 1'b1) ? 1'b1 : 1'b0; // F --0--> C (010), F --1--> D (011)
			end
			default: begin // Handle any unexpected states (shouldn't happen, but good practice)
				Y2 = 1'b0; // Default to a safe state
			end
		endcase
	end

endmodule