module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  reg A, B;  // One-hot encoded states
  wire next_A, next_B;
  reg z;

  // State Transition Logic
  always @(*) begin
    next_A = 0;
    next_B = 0;
    case ({A, B})
      2'b10: begin // State A
        if (x == 0) begin
          next_A = 1;
          next_B = 0;
          z = 0;
        end else begin
          next_A = 0;
          next_B = 1;
          z = 1;
        end
      end
      2'b01: begin // State B
        next_B = 1;
        if (x == 0) begin
          z = 1;
        end else begin
          z = 0;
        end
      end
      default: begin
        next_A = 1;
        next_B = 0;
        z = 0;
      end
    endcase
  end

  // State Update Logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      A <= 1;
      B <= 0;
      z <= 0;
    end else begin
      A <= next_A;
      B <= next_B;
    end
  end

endmodule