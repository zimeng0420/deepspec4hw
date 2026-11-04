module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  // Define the states
  localparam STATE_A = 1'b0;
  localparam STATE_B = 1'b1;

  // State register
  reg current_state;
  reg next_state;

  // Output register
  reg out_r;
  assign out = out_r;

  // State transition logic (combinational)
  always @(*) begin
    case (current_state)
      STATE_A: begin
        if (in == 0) begin
          next_state = STATE_B;
        end else begin
          next_state = STATE_A;
        end
      end
      STATE_B: begin
        if (in == 0) begin
          next_state = STATE_A;
        end else begin
          next_state = STATE_B;
        end
      end
      default: next_state = STATE_B; // Default to reset state
    endcase
  end

  // State update logic (sequential)
  always @(posedge clk) begin
    if (reset) begin
      current_state <= STATE_B;
    end else begin
      current_state <= next_state;
    end
  end

  // Output logic (combinational - Moore)
  always @(current_state) begin
    case (current_state)
      STATE_A: out_r = 0;
      STATE_B: out_r = 1;
      default: out_r = 1; // Default to reset state output
    endcase
  end

endmodule