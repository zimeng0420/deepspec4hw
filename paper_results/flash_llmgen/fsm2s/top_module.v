module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

  reg current_state;
  reg next_state;

  // State definitions
  localparam OFF = 0;
  localparam ON  = 1;

  // State transition logic (combinational)
  always @(*) begin
    case (current_state)
      OFF: begin
        if (j == 0)
          next_state = OFF;
        else
          next_state = ON;
      end
      ON: begin
        if (k == 0)
          next_state = ON;
        else
          next_state = OFF;
      end
      default: next_state = OFF; // Handle unexpected state
    endcase
  end

  // State update (sequential)
  always @(posedge clk) begin
    if (reset)
      current_state <= OFF;
    else
      current_state <= next_state;
  end

  // Output logic (combinational)
  assign out = current_state;

endmodule