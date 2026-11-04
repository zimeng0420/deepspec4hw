module top_module (
    input clk,
    input reset,
    input w,
    output z
);

  // Define the states
  parameter A = 3'b000;
  parameter B = 3'b001;
  parameter C = 3'b010;
  parameter D = 3'b011;
  parameter E = 3'b100;
  parameter F = 3'b101;

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // Output register (optional, but good practice for clarity)
  reg z_reg;
  assign z = z_reg;

  // Next state logic
  always @(*) begin
    case (current_state)
      A: begin
        if (w == 0) next_state = B;
        else next_state = A;
      end
      B: begin
        if (w == 0) next_state = C;
        else next_state = D;
      end
      C: begin
        if (w == 0) next_state = E;
        else next_state = D;
      end
      D: begin
        if (w == 0) next_state = F;
        else next_state = A;
      end
      E: begin
        if (w == 0) next_state = E;
        else next_state = D;
      end
      F: begin
        if (w == 0) next_state = C;
        else next_state = D;
      end
      default: next_state = A; // Should not happen, but good to have a default
    endcase
  end

  // Output logic
  always @(*) begin
    if (current_state == E || current_state == F) begin
      z_reg = 1;
    end else begin
      z_reg = 0;
    end
  end

  // State update logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

endmodule