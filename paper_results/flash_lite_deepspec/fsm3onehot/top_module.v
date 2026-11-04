module top_module (
	input in,
	input [3:0] state,
	output reg [3:0] next_state,
	output out
);

  // State Definitions (Implicitly defined by one-hot encoding)
  // localparam A = 4'b0001;
  // localparam B = 4'b0010;
  // localparam C = 4'b0100;
  // localparam D = 4'b1000;

  // Next State Logic
  always @(*) begin
    case (state)
      4'b0001: // A
        if (!in) next_state = 4'b0001; // A
        else     next_state = 4'b0010; // B
      4'b0010: // B
        if (!in) next_state = 4'b0100; // C
        else     next_state = 4'b0010; // B
      4'b0100: // C
        if (!in) next_state = 4'b0001; // A
        else     next_state = 4'b1000; // D
      4'b1000: // D
        if (!in) next_state = 4'b0100; // C
        else     next_state = 4'b0010; // B
      default: next_state = 4'b0001; // Default to A
    endcase
  end

  // Output Logic
  assign out = state[3]; // Output is high when in state D

endmodule