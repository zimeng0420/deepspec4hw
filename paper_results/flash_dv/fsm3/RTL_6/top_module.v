module top_module(
    input clk,
    input areset,
    input in,
    output out
);

  // State encoding
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  reg [1:0] current_state;
  reg [1:0] next_state;

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        if (in == 0) next_state = A;
        else next_state = B;
      end
      B: begin
        if (in == 0) next_state = C;
        else next_state = B;
      end
      C: begin
        if (in == 0) next_state = A;
        else next_state = D;
      end
      D: begin
        if (in == 0) next_state = C;
        else next_state = B;
      end
      default: next_state = A; // Default state
    endcase
  end

  // Output logic
  always @(*) begin
    case (current_state)
      A: out = 0;
      B: out = 0;
      C: out = 0;
      D: out = 1;
      default: out = 0; // Default output
    endcase
  end

  // State update logic with asynchronous reset
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

endmodule