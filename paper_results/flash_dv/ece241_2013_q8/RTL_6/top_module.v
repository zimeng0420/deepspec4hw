module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

  reg [1:0] state;
  reg [1:0] next_state;

  // State Encoding:
  // S0 = 00
  // S1 = 01
  // S2 = 10

  // Next State Logic (Combinational)
  always @(*) begin
    case (state)
      2'b00: begin // S0
        if (x) begin
          next_state = 2'b01; // S1
        end else begin
          next_state = 2'b00; // S0
        end
        z = 0;
      end
      2'b01: begin // S1
        if (x) begin
          next_state = 2'b01; // S1
        end else begin
          next_state = 2'b10; // S2
        end
        z = 0;
      end
      2'b10: begin // S2
        if (x) begin
          next_state = 2'b01; // S1
          z = 1;
        end else begin
          next_state = 2'b00; // S0
          z = 0;
        end
      end
      default: begin
        next_state = 2'b00;
        z = 0;
      end
    endcase
  end

  // State Update (Sequential)
  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= 2'b00; // Reset to S0
    end else begin
      state <= next_state;
    end
  end

endmodule