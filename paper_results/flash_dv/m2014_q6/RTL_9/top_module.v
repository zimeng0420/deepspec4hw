module top_module (
    input clk,
    input reset,
    input w,
    output z
);

  // Define the states
  localparam A = 3'b000;
  localparam B = 3'b001;
  localparam C = 3'b010;
  localparam D = 3'b011;
  localparam E = 3'b100;
  localparam F = 3'b101;

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // Output register (optional, depending on requirements.  Using combinational assignment for now)
  //reg z;

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
      default: next_state = A; // Should never happen, but good practice
    endcase
  end

  // Output logic (combinational)
  assign z = (current_state == E) || (current_state == F);

  // State update logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= A;
    end else begin
      current_state <= next_state;
    end
  end

endmodule