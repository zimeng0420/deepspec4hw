module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

  // State definition
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
    DONE_STATE
  } state_t;

  reg state_t current_state, next_state;
  reg [3:0] delay;
  reg [19:0] counter; // Sufficient bits for (15+1)*1000 = 16000
  reg [3:0] current_count;

  // State transition logic
  always_comb begin
    next_state = current_state;
    counting = 0;
    done = 0;

    case (current_state)
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
        counting = 1;
      end
      COUNTING: begin
        counting = 1;
        if (counter == 0) begin
          next_state = DONE_STATE;
          counting = 0;
          done = 1;
        end else begin
          next_state = COUNTING;
        end
      end
      DONE_STATE: begin
        done = 1;
        counting = 0;
        if (ack) next_state = IDLE;
        else next_state = DONE_STATE;
      end
      default: next_state = IDLE;
    endcase
  end

  // State update logic
  always_ff @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      delay <= 0;
      counter <= 0;
      current_count <= 0;
      counting <= 0;
      done <= 0;
    end else begin
      current_state <= next_state;
      if (current_state == LOAD_DELAY_1) begin
        delay[3] <= data;
      end else if (current_state == LOAD_DELAY_2) begin
        delay[2] <= data;
      end else if (current_state == LOAD_DELAY_3) begin
        delay[1] <= data;
      end else if (current_state == LOAD_DELAY_4) begin
        delay[0] <= data;
        counter <= (delay + 1) * 1000;
        current_count <= delay;
      end else if (current_state == COUNTING) begin
        if (counter > 0) begin
            counter <= counter - 1;
            if((counter % 1000) == 0 && current_count > 0)
                current_count <= current_count - 1;
        end
      end else if (current_state == DONE_STATE) begin
        // Do nothing, wait for ack
      end
    end
  end

  // Output logic
  assign count = (counting) ? current_count : 4'bx;

endmodule