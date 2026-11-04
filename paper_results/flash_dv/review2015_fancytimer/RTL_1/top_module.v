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

  reg state, next_state;
  reg [3:0] delay;
  reg [19:0] counter; // Enough bits to count up to 15 * 1000 = 15000.  2^14 = 16384, so 14 bits would be enough. Using 20 for headroom.
  reg [3:0] current_count;

  // Next State Logic
  always_comb begin
    next_state = state;
    counting = 0;
    done = 0;

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
      end
      COUNTING: begin
        counting = 1;
        if (counter == 0) next_state = DONE;
        else next_state = COUNTING;
      end
      DONE: begin
        done = 1;
        if (ack) next_state = IDLE;
        else next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

  // State and Data Register Update
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      delay <= 0;
      counter <= 0;
      current_count <= 0;
      counting <= 0;
      done <= 0;
    end else begin
      state <= next_state;

      case (state)
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
      endcase

      if (state == LOAD_DELAY_4) begin
        counter <= (delay + 1) * 1000 -1;
      end

    end
  end

  // Output Logic
  assign count = (counting) ? (counter/1000) : 4'bx;

endmodule