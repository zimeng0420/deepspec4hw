module top_module (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err
);

  // State definition
  parameter S_RESET = 3'b000;
  parameter S_0     = 3'b001;
  parameter S_1     = 3'b010;
  parameter S_11    = 3'b011;
  parameter S_111   = 3'b100;
  parameter S_1111  = 3'b101;
  parameter S_11111 = 3'b110;
  parameter S_111111= 3'b111;

  // State register
  reg [2:0] current_state;
  reg [2:0] next_state;

  // Output registers
  reg disc_r, flag_r, err_r;

  // Next state logic
  always_comb begin
    next_state = current_state; // Default: stay in the same state
    case (current_state)
      S_RESET: begin
        if (in == 1'b0) next_state = S_0;
        else             next_state = S_1;
      end
      S_0: begin
        if (in == 1'b0) next_state = S_0;
        else             next_state = S_1;
      end
      S_1: begin
        if (in == 1'b0) next_state = S_0;
        else             next_state = S_11;
      end
      S_11: begin
        if (in == 1'b0) next_state = S_0;
        else             next_state = S_111;
      end
      S_111: begin
        if (in == 1'b0) next_state = S_0;
        else             next_state = S_1111;
      end
      S_1111: begin
        if (in == 1'b0) next_state = S_0;
        else             next_state = S_11111;
      end
      S_11111: begin
        if (in == 1'b0) begin
          next_state = S_0;
        end else          next_state = S_111111;
      end
      S_111111: begin
        if (in == 1'b0) begin
          next_state = S_0;
        end else          next_state = S_111111; //Stay in this state to signal error
      end
      default: next_state = S_RESET;
    end
  end

  // State transition logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= S_RESET;
      disc_r <= 1'b0;
      flag_r <= 1'b0;
      err_r  <= 1'b0;
    end else begin
      current_state <= next_state;
      disc_r <= 1'b0;
      flag_r <= 1'b0;
      err_r  <= 1'b0;

      if (current_state == S_11111 && in == 1'b0) begin
        disc_r <= 1'b1;
      end else if (current_state == S_111111 && in == 1'b0) begin
        flag_r <= 1'b1;
      end else if (current_state == S_111111 && in == 1'b1) begin
        err_r <= 1'b1;
      end
    end
  end

  // Output assignment
  assign disc = disc_r;
  assign flag = flag_r;
  assign err  = err_r;

endmodule