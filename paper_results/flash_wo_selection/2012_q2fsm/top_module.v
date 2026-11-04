module top_module (
    input clk,
    input reset,
    input w,
    output z
);

  // State encoding
  parameter A = 3'b000;
  parameter B = 3'b001;
  parameter C = 3'b010;
  parameter D = 3'b011;
  parameter E = 3'b100;
  parameter F = 3'b101;

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // Output register
  reg z_reg;
  assign z = z_reg;

  // State flip-flops
  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

  // State table (next state logic)
  always @(*) begin
    case (current_state)
      A: begin
        if (w == 1) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
        if (w == 1) begin
          next_state = C;
        end else begin
          next_state = D;
        end
      end
      C: begin
        if (w == 1) begin
          next_state = E;
        end else begin
          next_state = D;
        end
      end
      D: begin
        if (w == 1) begin
          next_state = F;
        end else begin
          next_state = A;
        end
      end
      E: begin
        if (w == 1) begin
          next_state = E;
        end else begin
          next_state = D;
        end
      end
      F: begin
        if (w == 1) begin
          next_state = C;
        end else begin
          next_state = D;
        end
      end
      default: next_state = A; // Should not happen, but good practice
    endcase
  end

  // Output logic
  always @(*) begin
    if ((current_state == E || current_state == F) && w == 1) begin
      z_reg = 1;
    end else begin
      z_reg = 0;
    end
  end

endmodule