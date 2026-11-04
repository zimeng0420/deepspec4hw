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

  // Output
  assign z = (current_state == E) || (current_state == F);

  // State transition logic (combinational)
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
      default: next_state = A; // Should not happen, but good practice
    endcase
  end

  // State update logic (sequential)
  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

endmodule