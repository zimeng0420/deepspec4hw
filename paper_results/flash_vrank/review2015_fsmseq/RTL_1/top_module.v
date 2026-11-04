module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting);

  // Define the states
  typedef enum {S0, S1, S2, S3, S4} state_t;
  reg state, next_state;

  // State transition logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      start_shifting <= 0;
    end else begin
      state <= next_state;
      if (next_state == S4) begin
        start_shifting <= 1;
      end
    end
  end

  // Next state logic
  always @(*) begin
    case (state)
      S0: begin
        if (data == 1)
          next_state = S1;
        else
          next_state = S0;
      end
      S1: begin
        if (data == 1)
          next_state = S2;
        else
          next_state = S0;
      end
      S2: begin
        if (data == 0)
          next_state = S3;
        else
          next_state = S1;
      end
      S3: begin
        if (data == 1)
          next_state = S4;
        else
          next_state = S0;
      end
      S4: begin //sequence found, stay in this state
        next_state = S4;
      end
      default: next_state = S0;
    endcase
  end
endmodule