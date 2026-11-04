module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  // Define the states
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // State register
  reg state;

  // Next state logic
  reg next_state;

  // Output logic
  reg out;

  always @(posedge clk or posedge areset) begin
    if (areset) begin
      state <= A;
    end else begin
      state <= next_state;
    end
  end

  always @(*) begin
    case (state)
      A: begin
        if (in == 0) begin
          next_state = A;
        end else begin
          next_state = B;
        end
        out = 0;
      end
      B: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
        out = 0;
      end
      C: begin
        if (in == 0) begin
          next_state = A;
        end else begin
          next_state = D;
        end
        out = 0;
      end
      D: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
        out = 1;
      end
      default: begin
        next_state = A;
        out = 0;
      end
    endcase
  end

  assign out = out;  // Make sure output is assigned, remove potential latch.

endmodule