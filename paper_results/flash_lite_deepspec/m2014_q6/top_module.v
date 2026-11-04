module top_module (
	input clk,
	input reset,
	input w,
	output z
);

  // State Definition
  parameter A = 3'b000;
  parameter B = 3'b001;
  parameter C = 3'b010;
  parameter D = 3'b011;
  parameter E = 3'b100;
  parameter F = 3'b101;

  // State Register
  reg [2:0] current_state;

  // Output Register
  reg z;

  // State Transition Logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= A; // Initialize to state A on reset
    end else begin
      case (current_state)
        A:  current_state <= (w) ? A : B;
        B:  current_state <= (w) ? D : C;
        C:  current_state <= (w) ? D : E;
        D:  current_state <= (w) ? A : F;
        E:  current_state <= (w) ? D : E;
        F:  current_state <= (w) ? D : C;
        default: current_state <= A; // Default to A (should not happen)
      endcase
    end
  end

  // Output Logic
  always @(*) begin
    case (current_state)
      E, F: z = 1;
      default: z = 0;
    endcase
  end

endmodule