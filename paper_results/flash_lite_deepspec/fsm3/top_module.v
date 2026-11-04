module top_module (
	input clk,
	input in,
	input areset,
	output out
);

  // State declaration
  reg [1:0] state;

  // State definitions (using parameters for readability and maintainability)
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // Next state logic
  reg [1:0] next_state;

  // Output logic
  always @(*) begin
    case (state)
      A: out = 1'b0;
      B: out = 1'b0;
      C: out = 1'b0;
      D: out = 1'b1;
      default: out = 1'b0; // Default output
    endcase
  end

  // State update with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A; // Asynchronous reset to state A
    end else begin
      case (state)
        A: next_state = (in) ? B : A;
        B: next_state = (in) ? B : C;
        C: next_state = (in) ? D : A;
        D: next_state = (in) ? B : C;
        default: next_state = A; // Default next state
      endcase
      state <= next_state;
    end
  end

endmodule