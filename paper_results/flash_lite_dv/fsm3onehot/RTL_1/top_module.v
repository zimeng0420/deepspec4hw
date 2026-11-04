module top_module(
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
      A: begin
        if (!in) next_state = A;
        else next_state = B;
      end
      B: begin
        if (!in) next_state = C;
        else next_state = B;
      end
      C: begin
        if (!in) next_state = A;
        else next_state = D;
      end
      D: begin
        if (!in) next_state = C;
        else next_state = B;
      end
      default: next_state = A; // Default state (error handling)
    endcase
  end

  // Output Logic
  assign out = state[3]; // Output is '1' when in state D

endmodule