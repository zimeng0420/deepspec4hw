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
  reg [2:0] state;

  // Output register (Moore machine)
  reg z_reg;
  assign z = z_reg;

  // Next state logic
  reg [2:0] next_state;

  always @(*) begin
    case (state)
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

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= A;
      z_reg <= 0;
    end else begin
      state <= next_state;
      case (next_state)
        A: z_reg <= 0;
        B: z_reg <= 0;
        C: z_reg <= 0;
        D: z_reg <= 0;
        E: z_reg <= 1;
        F: z_reg <= 1;
        default: z_reg <= 0;
      endcase
    end
  end

endmodule