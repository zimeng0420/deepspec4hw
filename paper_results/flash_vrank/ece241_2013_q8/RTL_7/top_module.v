module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

  reg [1:0] state;

  // Define the states
  parameter S0 = 2'b00; // Initial state
  parameter S1 = 2'b01; // Received a '1'
  parameter S2 = 2'b10; // Received a '10'

  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= S0;
      z <= 0;
    end else begin
      case (state)
        S0: begin
          if (x == 1) begin
            state <= S1;
            z <= 0;
          end else begin
            state <= S0;
            z <= 0;
          end
        end
        S1: begin
          if (x == 0) begin
            state <= S2;
            z <= 0;
          end else begin
            state <= S1;
            z <= 0;
          end
        end
        S2: begin
          if (x == 1) begin
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