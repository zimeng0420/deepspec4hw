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

  reg state_t current_state, next_state;

  // Internal signals
  reg [3:0] delay;
  reg [11:0] counter; // Sufficient to count up to 15 * 1000
  reg [3:0] count_display;

  // State machine logic
  always_comb begin
    next_state = current_state;
    counting = 0;
    done = 0;

    case (current_state)
      IDLE: begin
        if (data) next_state = DETECT_1;
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
        next_state = LOAD_DELAY_2;
      end
      LOAD_DELAY_2: begin
        next_state = LOAD_DELAY_3;
      end
      LOAD_DELAY_3: begin
        next_state = LOAD_DELAY_4;
      end
      LOAD_DELAY_4: begin
        next_state = COUNTING;
        counting = 1;
      end
      COUNTING: begin
        counting = 1;
        if (counter == 0) begin
          next_state = DONE;
          counting = 0;
          done = 1;
        end
      end
      DONE: begin
        done = 1;
        if (ack) next_state = IDLE;
      end
      default: next_state = IDLE;
    endcase
  end

  // Sequential logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      delay <= 0;
      counter <= 0;
      counting <= 0;
      done <= 0;
      count_display <= 0;
    end else begin
      current_state <= next_state;

      case (current_state)
        LOAD_DELAY_1: delay[3] <= data;
        LOAD_DELAY_2: delay[2] <= data;
        LOAD_DELAY_3: delay[1] <= data;
        LOAD_DELAY_4: delay[0] <= data;
        COUNTING: begin
          if (counter > 0) begin
            counter <= counter - 1;
          end
        end
        default: ;
      end

      if (current_state == DETECT_1101) begin
        // Initialize counter after delay is loaded
        counter <= (delay + 1) * 1000 - 1;
      end
    end
  end

  // Output logic
  assign count = (counting) ? (counter / 1000) : 4'bx;
endmodule