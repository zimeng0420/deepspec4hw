module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  // State encoding
  localparam A = 0;
  localparam B = 1;

  reg state;

  // Output assignment (Moore machine)
  assign out = state;

  always @(posedge clk, posedge areset) begin
    if (areset) begin
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
        default: state <= B; // Ensure a known state after reset
      endcase
    end
  end

endmodule