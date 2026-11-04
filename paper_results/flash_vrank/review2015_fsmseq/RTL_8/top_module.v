module top_module(
    input clk,
    input reset,
    input data,
    output start_shifting);

  parameter S_IDLE = 0;
  parameter S_ONE = 1;
  parameter S_TWO = 2;
  parameter S_THREE = 3;
  parameter S_FOUR = 4;
  parameter S_FOUND = 5;

  reg state;
  reg next_state;
  reg start_shifting_r;

  always @(posedge clk) begin
    if (reset) begin
      state <= S_IDLE;
      start_shifting_r <= 0;
    end else begin
      state <= next_state;
      start_shifting_r <= (state == S_FOUND) ? 1'b1 : start_shifting_r;
    end
  end

  always @(*) begin
    case (state)
      S_IDLE: begin
        if (data == 1)
          next_state = S_ONE;
        else
          next_state = S_IDLE;
      end
      S_ONE: begin
        if (data == 1)
          next_state = S_TWO;
        else
          next_state = S_IDLE;
      end
      S_TWO: begin
        if (data == 0)
          next_state = S_THREE;
        else
          next_state = S_ONE;
      end
      S_THREE: begin
        if (data == 1)
          next_state = S_FOUR;
        else
          next_state = S_IDLE;
      end
      S_FOUR: begin
        next_state = S_FOUND;
      end
      S_FOUND: begin
        next_state = S_FOUND;
      end
      default: begin
        next_state = S_IDLE;
      end
    endcase
  end

  assign start_shifting = start_shifting_r;

endmodule