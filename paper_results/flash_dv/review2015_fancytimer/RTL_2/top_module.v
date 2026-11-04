module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

  // State machine definition
  typedef enum logic [3:0] {
    IDLE,
    DETECT_1,
    DETECT_11,
    DETECT_110,
    DETECT_1101,
    LOAD_DELAY_1,
    LOAD_DELAY_2,
    LOAD_DELAY_3,
    LOAD_DELAY_4,
    COUNTING,
    DONE
  } state_t;

  reg state, next_state;
  reg [3:0] delay;
  reg [19:0] counter; // Enough bits to count up to 15 * 1000 + 1000 = 16000
  reg [3:0] count_reg;

  // State machine logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      counter <= 0;
      count_reg <= 0;
    end else begin
      state <= next_state;
      count_reg <= count_reg; // Default assignment
      counting <= 0;
      done <= 0;
      if (state == COUNTING) begin
        counting <= 1;
      end else if (state == DONE) begin
        done <= 1;
      end
    end
  end

  always_comb begin
    next_state = state;
    case (state)
      IDLE: begin
        if (data) next_state = DETECT_1;
        else next_state = IDLE;
      end
      DETECT_1: begin
        if (data) next_state = DETECT_11;
        else next_state = IDLE;
      end
      DETECT_11: begin
        if (!data) next_state = DETECT_110;
        else next_state = IDLE;
      end
      DETECT_110: begin
        if (data) next_state = DETECT_1101;
        else next_state = IDLE;
      end
      DETECT_1101: begin
        next_state = LOAD_DELAY_1;
      end
      LOAD_DELAY_1: begin
        delay[3] = data;
        next_state = LOAD_DELAY_2;
      end
      LOAD_DELAY_2: begin
        delay[2] = data;
        next_state = LOAD_DELAY_3;
      end
      LOAD_DELAY_3: begin
        delay[1] = data;
        next_state = LOAD_DELAY_4;
      end
      LOAD_DELAY_4: begin
        delay[0] = data;
        next_state = COUNTING;
        counter = 0;
      end
      COUNTING: begin
        if (counter < ((delay + 1) * 1000 -1)) begin
          next_state = COUNTING;
        end else begin
          next_state = DONE;
        end
      end
      DONE: begin
        if (ack) next_state = IDLE;
        else next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

  always @(posedge clk) begin
    if (reset) begin
      counter <= 0;
    end else if (state == COUNTING) begin
      if (counter < ((delay + 1) * 1000 - 1)) begin
        counter <= counter + 1;
      end else begin
        counter <= counter;
      end
    end else begin
      counter <= 0;
    end
  end

  assign count = (counting) ? (delay - (counter / 1000)) : 4'bx;

endmodule