module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg [1:0] state; // One-hot encoding: state[0] = A, state[1] = B

  // State definitions
  localparam A = 2'b10;
  localparam B = 2'b01;

  // Next state logic and reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
    end else begin
      case (state)
        A: begin
          if (x) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          state <= B;
        end
        default: state <= A; // Should not happen, but good practice
      endcase
    end
  end

  // Output logic (Mealy)
  assign z = (state[0] & x) | (state[1] & ~x);

endmodule