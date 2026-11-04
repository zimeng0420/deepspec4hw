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
    DONE_STATE
  } state_t;

  reg state, next_state;

  // Internal registers
  reg [3:0] delay;
  reg [12:0] counter; // Counter large enough to hold (15+1)*1000 = 16000
  reg [2:0] pattern_buffer; //stores last three bits for pattern detection

  // Output assignment
  assign count = (counting) ? (counter/1000) : 4'bx;

  // State machine logic
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      counting <= 0;
      done <= 0;
      counter <= 0;
      pattern_buffer <= 3'b000;
      delay <= 4'b0000;
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
        if (data == 1'b1) begin
          next_state = DETECT_1;
          pattern_buffer = {pattern_buffer[1:0], data};
        end else begin
          next_state = IDLE;
          pattern_buffer = 3'b000;
        end
      end
      DETECT_1: begin
        if (data == 1'b1) begin
          next_state = DETECT_11;
          pattern_buffer = {pattern_buffer[1:0], data};
        end else begin
          next_state = IDLE;
          pattern_buffer = 3'b000;
        end
      end
      DETECT_11: begin
        if (data == 1'b0) begin
          next_state = DETECT_110;
          pattern_buffer = {pattern_buffer[1:0], data};
        end else begin
          next_state = IDLE;
          pattern_buffer = 3'b000;
        end
      end
      DETECT_110: begin
        if (data == 1'b1) begin
          next_state = DETECT_1101;
          pattern_buffer = {pattern_buffer[1:0], data};
        end else begin
          next_state = IDLE;
          pattern_buffer = 3'b000;
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
        counter = (delay + 1) * 1000;
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
        if (ack == 1'b1) begin
          next_state = IDLE;
        end else begin
          next_state = DONE_STATE;
        end
      end
      default: next_state = IDLE;
    endcase
  end

endmodule