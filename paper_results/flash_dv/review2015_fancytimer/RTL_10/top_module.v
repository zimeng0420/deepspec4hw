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
  reg [19:0] counter; // Sufficient bits for (15+1)*1000 = 16000 = 0x3E80 which needs 15 bits. Add some extra bits.
  reg [3:0] count_reg;

  // State Transition Logic
  always_comb begin
    next_state = IDLE; // Default next state
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
        if (counter == 0) next_state = DONE;
        else next_state = COUNTING;
      end
      DONE: begin
        if (ack) next_state = IDLE;
        else next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

  // State and Output Update
  always_ff @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      delay <= 0;
      counter <= 0;
      count_reg <= 0;
    end else begin
      state <= next_state;

      case (state)
        IDLE: begin
          counting <= 0;
          done <= 0;
        end
        DETECT_1: begin
          counting <= 0;
          done <= 0;
        end
        DETECT_11: begin
          counting <= 0;
          done <= 0;
        end
        DETECT_110: begin
          counting <= 0;
          done <= 0;
        end
        DETECT_1101: begin
          counting <= 0;
          done <= 0;
        end
        LOAD_DELAY_1: begin
          delay[3] <= data;
          counting <= 0;
          done <= 0;
        end
        LOAD_DELAY_2: begin
          delay[2] <= data;
          counting <= 0;
          done <= 0;
        end
        LOAD_DELAY_3: begin
          delay[1] <= data;
          counting <= 0;
          done <= 0;
        end
        LOAD_DELAY_4: begin
          delay[0] <= data;
          counting <= 0;
          done <= 0;
          counter <= (delay + 1) * 1000; // Load initial counter value
          count_reg <= delay;
        end
        COUNTING: begin
          counting <= 1;
          done <= 0;
          if (counter > 0) begin
            counter <= counter - 1;
            if(counter % 1000 == 0 && counter != 0)
                count_reg <= count_reg - 1;
          end
        end
        DONE: begin
          counting <= 0;
          done <= 1;
        end
        default: begin
          counting <= 0;
          done <= 0;
        end
      endcase
    end
  end

  // Count Output Assignment
  assign count = (counting) ? count_reg : 4'bx;

endmodule