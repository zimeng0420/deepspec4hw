module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output out
);

  // Define the two states
  localparam OFF = 1'b0;
  localparam ON  = 1'b1;

  // State register
  reg current_state;

  // Output assignment (Moore machine)
  assign out = current_state;

  // State transition logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= OFF;
    end else begin
      case (current_state)
        OFF: begin
          if (j) begin
            current_state <= ON;
          end else begin
            current_state <= OFF;
          end
        end
        ON: begin
          if (k) begin
            current_state <= OFF;
          end else begin
            current_state <= ON;
          end
        end
        default: current_state <= OFF; // Handle undefined state
      endcase
    end
  end

endmodule