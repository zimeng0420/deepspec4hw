module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

  reg [1:0] state;
  localparam S0 = 2'b00; // Initial state
  localparam S1 = 2'b01; // Seen '1'
  localparam S2 = 2'b10; // Seen '10'

  always @ (negedge aresetn or posedge clk) begin
    if (!aresetn) begin
      state <= S0;
      z <= 0;
    end else begin
      case (state)
        S0: begin
          if (x) begin
            state <= S1;
            z <= 0;
          end else begin
            state <= S0;
            z <= 0;
          end
        end
        S1: begin
          if (x) begin
            state <= S1;
            z <= 0;
          end else begin
            state <= S2;
            z <= 0;
          end
        end
        S2: begin
          if (x) begin
            state <= S1;
            z <= 1;
          end else begin
            state <= S0;
            z <= 0;
          end
        end
        default: begin
          state <= S0;
          z <= 0;
        end
      endcase
    end
  end

endmodule