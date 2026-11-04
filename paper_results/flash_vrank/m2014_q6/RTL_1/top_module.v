module top_module (
    input clk,
    input reset,
    input w,
    output z
);

  reg [2:0] current_state, next_state;  // 3 bits needed to represent 6 states

  // Define state encoding
  parameter A = 3'b000;
  parameter B = 3'b001;
  parameter C = 3'b010;
  parameter D = 3'b011;
  parameter E = 3'b100;
  parameter F = 3'b101;


  // State transition logic (synchronous)
  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

  // Next state logic (combinational)
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
      default: next_state = A; // Default to state A if current_state is invalid
    endcase
  end

  // Output logic
  assign z = (current_state == E) ? 1 : ((current_state == F) ? 1: 0);


endmodule