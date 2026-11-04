module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

  // State Definitions (One-Hot Encoding)
  localparam A = 4'b0001;
  localparam B = 4'b0010;
  localparam C = 4'b0100;
  localparam D = 4'b1000;

  // Next State Logic
  always @(*) begin
    case (state)
      A: next_state = (in == 0) ? A : B;
      B: next_state = (in == 0) ? C : B;
      C: next_state = (in == 0) ? A : D;
      D: next_state = (in == 0) ? C : B;
      default: next_state = A; // Default to state A (reset state)
    endcase
  end

  // Output Logic
  always @(*) begin
    case (state)
      A: out = 0;
      B: out = 0;
      C: out = 0;
      D: out = 1;
      default: out = 0; // Default output
    endcase
  end

endmodule