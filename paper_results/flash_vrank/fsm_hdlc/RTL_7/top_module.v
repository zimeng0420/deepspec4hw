module top_module (
    input clk,
    input reset,
    input in,
    output disc,
    output flag,
    output err);

  // Define states
  localparam S_RESET = 0;
  localparam S_0     = 1;
  localparam S_1     = 2;
  localparam S_11    = 3;
  localparam S_111   = 4;
  localparam S_1111  = 5;
  localparam S_11111 = 6;
  localparam S_111110 = 7;
  localparam S_111111 = 8;
  localparam S_ERROR = 9;

  reg [3:0] state, next_state;
  reg disc_r, flag_r, err_r;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S_RESET;
    end else begin
      state <= next_state;
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      S_RESET: next_state = S_0;
      S_0:     next_state = (in == 0) ? S_0 : S_1;
      S_1:     next_state = (in == 0) ? S_0 : S_11;
      S_11:    next_state = (in == 0) ? S_0 : S_111;
      S_111:   next_state = (in == 0) ? S_0 : S_1111;
      S_1111:  next_state = (in == 0) ? S_0 : S_11111;
      S_11111: next_state = (in == 0) ? S_111110 : S_111111;
      S_111110:next_state = (in == 0) ? S_0 : S_1;
      S_111111:next_state = (in == 0) ? S_0 : S_ERROR;
      S_ERROR: next_state = (in == 0) ? S_0 : S_ERROR;
      default:  next_state = S_RESET;
    endcase
  end

  // Output logic
  always @(posedge clk) begin
    if (reset) begin
      disc_r <= 0;
      flag_r <= 0;
      err_r <= 0;
    end else begin
      disc_r <= 0;
      flag_r <= 0;
      err_r <= 0;

      if (state == S_111110) begin
        disc_r <= 1;
      end else if (state == S_111111 && in == 0) begin
        flag_r <= 1;
      end else if (state == S_ERROR) begin
        err_r <= 1;
      end
    end
  end

  assign disc = disc_r;
  assign flag = flag_r;
  assign err = err_r;

endmodule