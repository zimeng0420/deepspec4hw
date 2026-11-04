module top_module(
    input in,
    input [3:0] state,
    output reg [3:0] next_state,
    output out
);

  // State definitions (One-Hot Encoding)
  localparam A = 4'b0001;
  localparam B = 4'b0010;
  localparam C = 4'b0100;
  localparam D = 4'b1000;

  // Next State Logic
  always @(*) begin
    case (state)
      A: if (!in) next_state = A; else next_state = B;
      B: if (!in) next_state = C; else next_state = B;
      C: if (!in) next_state = A; else next_state = D;
      D: if (!in) next_state = C; else next_state = B;
      default: next_state = A; // Default state (should not happen)
    endcase
  end

  // Output Logic
  always @(*) begin
    case (state)
      A: out = 0;
      B: out = 0;
      C: out = 0;
      D: out = 1;
      default: out = 0; // Default output (should not happen)
    endcase
  end

endmodule