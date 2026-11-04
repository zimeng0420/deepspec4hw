module top_module(
    input clk,
    input areset,
    input x,
    output z
);

  reg [1:0] current_state;
  wire [1:0] next_state;

  // State encoding:
  // A: 2'b01
  // B: 2'b10

  // Next state logic
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
      default: next_state = 2'b01; // Should never happen, but good practice
    endcase
  end

  // Output logic
  assign z = (current_state[0] & ~x) | (current_state[1] & x);

  // State register
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= 2'b01; // Reset to state A
    end else begin
      current_state <= next_state;
    end
  end

endmodule