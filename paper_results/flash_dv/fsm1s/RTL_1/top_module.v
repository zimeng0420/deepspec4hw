module top_module (
    input clk,
    input in,
    input reset,
    output out
);

  reg state;
  reg out;

  // State definitions
  localparam A = 1'b0;
  localparam B = 1'b1;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= B;
    end else begin
      case (state)
        A: begin
          if (in == 0) begin
            state <= B;
          end else begin
            state <= A;
          end
        end
        B: begin
          if (in == 0) begin
            state <= A;
          end else begin
            state <= B;
          end
        end
        default: state <= B; // Should not happen, but good practice
      endcase
    end
  end

  // Output logic (Moore machine)
  always @(state) begin
    if (state == B) begin
      out = 1'b1;
    end else begin
      out = 1'b0;
    end
  end

endmodule