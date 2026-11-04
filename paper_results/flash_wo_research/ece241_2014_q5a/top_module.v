module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // Define states
  localparam S_ZERO = 0;
  localparam S_ONE  = 1;

  // State register
  reg current_state;
  reg next_state;

  // Output register
  reg z_reg;

  // Next state logic
  always @(*) begin
    case (current_state)
      S_ZERO: begin
        if (x == 1) begin
          next_state = S_ONE;
        end else begin
          next_state = S_ZERO;
        end
      end
      S_ONE: begin
        if (x == 1) begin
          next_state = S_ONE;
        end else begin
          next_state = S_ZERO;
        end
      end
      default: next_state = S_ZERO; // Should not happen, but good practice
    endcase
  end

  // State update logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= S_ZERO;
    end else begin
      current_state <= next_state;
    end
  end

  // Output logic (Moore machine: output depends only on current state)
  always @(*) begin
    case (current_state)
      S_ZERO: z_reg = 0;
      S_ONE:  z_reg = 1;
      default: z_reg = 0; // Default output
    endcase
  end

  assign z = z_reg;

endmodule