module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

  reg [1:0] current_state;
  reg [1:0] next_state;

  // State Encoding
  localparam STATE_A = 2'b00; // Initial state
  localparam STATE_B = 2'b01; // '1' detected
  localparam STATE_C = 2'b10; // '10' detected

  // Next State Logic
  always @(*) begin
    case (current_state)
      STATE_A: begin
        if (x)
          next_state = STATE_B;
        else
          next_state = STATE_A;
      end
      STATE_B: begin
        if (!x)
          next_state = STATE_C;
        else
          next_state = STATE_B;
      end
      STATE_C: begin
        if (x)
          next_state = STATE_B;
        else
          next_state = STATE_A;
      end
      default: next_state = STATE_A; // Should not happen, but good practice
    endcase
  end

  // Output Logic
  always @(*) begin
    z = (current_state == STATE_C) && x;
  end

  // State Update Logic (Negative Edge Triggered, Asynchronous Reset)
  always @(negedge clk, negedge aresetn) begin
    if (!aresetn) begin
      current_state <= STATE_A;
    end else begin
      current_state <= next_state;
    end
  end

endmodule