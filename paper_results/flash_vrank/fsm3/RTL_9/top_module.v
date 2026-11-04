module top_module (
    input clk,
    input in,
    input areset,
    output out
);

  reg [1:0] current_state, next_state;
  
  // Define state encoding
  parameter A = 2'b00;
  parameter B = 2'b01;
  parameter C = 2'b10;
  parameter D = 2'b11;

  // State transition logic
  always @(posedge clk or posedge areset) begin
    if (areset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        if (in == 0) begin
          next_state = A;
        end else begin
          next_state = B;
        end
      end
      B: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
      end
      C: begin
        if (in == 0) begin
          next_state = A;
        end else begin
          next_state = D;
        end
      end
      D: begin
        if (in == 0) begin
          next_state = C;
        end else begin
          next_state = B;
        end
      end
      default: next_state = A; // Should never happen, but good practice
    endcase
  end

  // Output logic
  assign out = (current_state == D) ? 1 : 0;

endmodule