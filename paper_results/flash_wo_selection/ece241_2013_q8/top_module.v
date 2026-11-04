module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

  reg [1:0] current_state;
  localparam S0 = 2'b00;
  localparam S1 = 2'b01;
  localparam S2 = 2'b10;

  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      current_state <= S0;
      z <= 0;
    end else begin
      case (current_state)
        S0: begin
          if (x) begin
            current_state <= S1;
          end else begin
            current_state <= S0;
          end
          z <= 0;
        end
        S1: begin
          if (x) begin
            current_state <= S1;
          end else begin
            current_state <= S2;
          end
          z <= 0;
        end
        S2: begin
          if (x) begin
            current_state <= S1;
            z <= 1;
          end else begin
            current_state <= S0;
            z <= 0;
          end
        end
        default: begin
          current_state <= S0;
          z <= 0;
        end
      endcase
    end
  end

endmodule