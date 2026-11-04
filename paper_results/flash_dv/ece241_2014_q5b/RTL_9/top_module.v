module top_module(
    input clk,
    input x,
    input areset,
    output z
);

  reg [1:0] current_state;
  wire [1:0] next_state;

  // State Encoding:
  // A: 2'b01
  // B: 2'b10

  // Next State Logic
  always @(*) begin
    case (current_state)
      2'b01: begin // State A
        if (x == 0) begin
          next_state = 2'b01;
        end else begin
          next_state = 2'b10;
        end
      end
      2'b10: begin // State B
        next_state = 2'b10;
      end
      default: next_state = 2'b01; //Should not happen, but good to have a default
    endcase
  end

  // Output Logic
  assign z = (current_state[0] & ~x) | (current_state[1] & x);

  // State Register
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= 2'b01; // Reset to state A
    end else begin
      current_state <= next_state;
    end
  end

endmodule