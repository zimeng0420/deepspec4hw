module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // Define the states
  localparam S_ZERO = 1'b0;
  localparam S_ONE  = 1'b1;

  // State register
  reg current_state;
  reg next_state;

  // Output register
  reg z_reg;
  assign z = z_reg;

  // State transition logic (combinational)
  always @(*) begin
    case (current_state)
      S_ZERO: begin
        if (x == 1'b1) begin
          next_state = S_ONE;
        end else begin
          next_state = S_ZERO;
        end
      end
      S_ONE: begin
        next_state = S_ONE;
      end
      default: next_state = S_ZERO; // Should never happen, but good practice
    endcase
  end

  // Output logic (combinational)
  always @(*) begin
    case (current_state)
      S_ZERO: z_reg = x;
      S_ONE:  z_reg = ~x;
      default: z_reg = 1'bx; // Undefined output during reset (or error)
    endcase
  end


  // State update (sequential)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= S_ZERO;
    end else begin
      current_state <= next_state;
    end
  end

endmodule