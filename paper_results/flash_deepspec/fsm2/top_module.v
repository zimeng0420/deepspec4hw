module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output out
);

  reg current_state;
  parameter OFF = 0, ON = 1;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= OFF;
    end else begin
      case (current_state)
        OFF: begin
          if (j == 1) begin
            current_state <= ON;
          end else begin
            current_state <= OFF;
          end
        end
        ON: begin
          if (k == 1) begin
            current_state <= OFF;
          end else begin
            current_state <= ON;
          end
        end
        default: current_state <= OFF; // Should not happen, but good practice
      endcase
    end
  end

  assign out = current_state;

endmodule