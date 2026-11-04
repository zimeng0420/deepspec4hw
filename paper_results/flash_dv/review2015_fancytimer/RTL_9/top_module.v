module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

  // State Definition
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

  reg state;
  reg next_state;

  // Internal Registers
  reg [3:0] delay;
  reg [11:0] counter; // Sufficient to count up to 15 * 1000
  reg [3:0] current_count;

  // State Machine Logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      counter <= 0;
      current_count <= 0;
    end else begin
      state <= next_state;
      if (state == COUNTING) begin
        if (counter > 0) begin
          counter <= counter - 1;
        end
      end
    end
  end

  always_comb begin
    next_state = state;
    counting = 0;
    done = 0;

    case (state)
      IDLE: begin
        if (data) begin
          next_state = DETECT_1;
        end else begin
          next_state = IDLE;
        end
      end
      DETECT_1: begin
        if (data) begin
          next_state = DETECT_11;
        end else begin
          next_state = IDLE;
        end
      end
      DETECT_11: begin
        if (!data) begin
          next_state = DETECT_110;
        end else begin
          next_state = IDLE;
        end
      end
      DETECT_110: begin
        if (data) begin
          next_state = DETECT_1101;
        end else begin
          next_state = IDLE;
        end
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
        counter = (delay + 1) * 1000 - 1;
        current_count = delay;
        next_state = COUNTING;
        counting = 1;
      end
      COUNTING: begin
        counting = 1;
        if (counter == 0) begin
          next_state = DONE;
          counting = 0;
          done = 1;
        end else begin
            if (counter % 1000 == 999) begin
                current_count = current_count - 1;
            end
          next_state = COUNTING;
        end
      end
      DONE: begin
        done = 1;
        if (ack) begin
          next_state = IDLE;
        end else begin
          next_state = DONE;
        end
      end
      default: begin
        next_state = IDLE;
      end
    endcase
  end

  // Output Logic
  assign count = (state == COUNTING) ? current_count : 4'bx;

endmodule