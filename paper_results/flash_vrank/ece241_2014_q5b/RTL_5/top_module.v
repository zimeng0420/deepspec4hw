module top_module (
    input clk,
    input areset,
    input x,
    output z
);

  // State encoding: A=2'b01, B=2'b10
  reg [1:0] state;
  reg [1:0] next_state;
  
  localparam A = 2'b01;
  localparam B = 2'b10;

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
        if (x == 0) begin
          next_state = A;
        end else begin
          next_state = B;
        end
      end
      B: begin
        next_state = B;
      end
      default: next_state = A; // Should not happen, but good practice
    endcase
  end

  assign z = (state == A && x == 1) ? 1 : 
             (state == B && x == 0) ? 1 : 0;

endmodule