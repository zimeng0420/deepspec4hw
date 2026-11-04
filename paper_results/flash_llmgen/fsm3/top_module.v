module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  // Define state encoding
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // State register
  reg [1:0] current_state;
  reg [1:0] next_state;

  // Output register (Moore machine)
  reg out;

  // State transition logic (combinational)
  always @(*) begin
    case (current_state)
      A: begin
        if (in == 0)
          next_state = A;
        else
          next_state = B;
      end
      B: begin
        if (in == 0)
          next_state = C;
        else
          next_state = B;
      end
      C: begin
        if (in == 0)
          next_state = A;
        else
          next_state = D;
      end
      D: begin
        if (in == 0)
          next_state = C;
        else
          next_state = B;
      end
      default: next_state = A; // Default to state A for safety
    endcase
  end

  // Output logic (combinational)
  always @(*) begin
    case (current_state)
      D: out = 1;
      default: out = 0;
    endcase
  end

  // State update logic (sequential)
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

endmodule