module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

  // Define states
  localparam A = 2'b00;
  localparam B = 2'b01;
  localparam C = 2'b10;
  localparam D = 2'b11;

  reg [1:0] current_state;
  reg [1:0] next_state;
  reg [2:0] w_history;
  reg exactly_two_ones;
  reg previous_exactly_two_ones;

  always @(posedge clk) begin
    if (reset) begin
      current_state <= A;
      z <= 0;
      w_history <= 3'b000;
      previous_exactly_two_ones <= 0;
    end else begin
      current_state <= next_state;
      z <= previous_exactly_two_ones;
      w_history <= {w_history[1:0], w};
      previous_exactly_two_ones <= exactly_two_ones;
    end
  end

  always @(*) begin
    next_state = current_state; // Default next state
    exactly_two_ones = (w_history[2] & w_history[1] & ~w_history[0]) |
                         (w_history[2] & ~w_history[1] & w_history[0]) |
                         (~w_history[2] & w_history[1] & w_history[0]);

    case (current_state)
      A: begin
        if (s) begin
          next_state = B;
        end else begin
          next_state = A;
        end
      end
      B: begin
        next_state = C;
      end
      C: begin
        next_state = D;
      end
      D: begin
        next_state = B;
      end
      default: next_state = A;
    endcase
  end

endmodule