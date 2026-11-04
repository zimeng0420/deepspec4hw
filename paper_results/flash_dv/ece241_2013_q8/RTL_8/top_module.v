module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

  reg [1:0] state;
  reg [1:0] next_state;

  // State Encoding:
  // S0: 2'b00
  // S1: 2'b01
  // S2: 2'b10

  // Next State Logic
  always @(*) begin
    case (state)
      2'b00: begin // S0
        if (x) begin
          next_state = 2'b01; // S1
        end else begin
          next_state = 2'b00; // S0
        end
      end
      2'b01: begin // S1
        if (x) begin
          next_state = 2'b01; // S1
        end else begin
          next_state = 2'b10; // S2
        end
      end
      2'b10: begin // S2
        if (x) begin
          next_state = 2'b01; // S1
        end else begin
          next_state = 2'b00; // S0
        end
      end
      default: next_state = 2'b00; // S0 (default to initial state)
    endcase
  end

  // Output Logic
  always @(*) begin
    if (state == 2'b10 && x) begin // S2 and x == 1
      z = 1;
    end else begin
      z = 0;
    end
  end

  // State Update Logic (Sequential)
  always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
      state <= 2'b00; // Reset to S0
    end else begin
      state <= next_state;
    end
  end

endmodule