module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

  // State Machine Definition
  parameter IDLE = 0,
            PATTERN_DETECTED = 1,
            CAPTURE_DELAY = 2,
            COUNTING = 3,
            DONE = 4;

  reg [2:0] current_state, next_state;

  // Pattern Detection
  reg [3:0] pattern_shift_reg;
  wire pattern_detected;
  assign pattern_detected = (pattern_shift_reg == 4'b1101);

  // Delay Capture
  reg [3:0] delay;
  reg [2:0] delay_bit_count;

  // Counter
  reg [12:0] counter; // Enough bits to count up to 15 * 1000
  reg [3:0] count_display;

  // Internal Signals
  reg delay_capture_complete;
  reg counter_enable;
  wire counter_zero;

  assign count = count_display;
  assign counter_zero = (counter == 0);

  // State Machine Logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      pattern_shift_reg <= 4'b0000;
      delay <= 4'b0000;
      delay_bit_count <= 3'b000;
      counter <= 13'd0;
      count_display <= 4'b0000;
      counting <= 0;
      done <= 0;
      delay_capture_complete <= 0;
      counter_enable <= 0;
    end else begin
      current_state <= next_state;

      case (current_state)
        IDLE: begin
          pattern_shift_reg <= {pattern_shift_reg[2:0], data};
          counting <= 0;
          done <= 0;
          delay_capture_complete <= 0;
          counter_enable <= 0;
        end

        PATTERN_DETECTED: begin
          delay_bit_count <= 3'b000;
          delay <= 4'b0000;
          pattern_shift_reg <= 4'b0000; // Reset pattern shift register
        end

        CAPTURE_DELAY: begin
          delay <= {delay[2:0], data};
          delay_bit_count <= delay_bit_count + 1'b1;
        end

        COUNTING: begin
          if (counter > 0) begin
            counter <= counter - 1;
            if (counter % 1000 == 0) begin
              count_display <= count_display - 1;
            end
          end
        end

        DONE: begin
          counting <= 0;
          if (ack) begin
            pattern_shift_reg <= 4'b0000;
          end
        end
      endcase
    end
  end

  // Next State Logic
  always @(*) begin
    next_state = current_state;
    case (current_state)
      IDLE: begin
        if (pattern_detected) begin
          next_state = PATTERN_DETECTED;
        end
      end

      PATTERN_DETECTED: begin
        next_state = CAPTURE_DELAY;
      end

      CAPTURE_DELAY: begin
        if (delay_bit_count == 3'b111) begin
          next_state = COUNTING;
        end
      end

      COUNTING: begin
        if (counter_zero) begin
          next_state = DONE;
        end
      end

      DONE: begin
        if (ack) begin
          next_state = IDLE;
        end
      end
    endcase
  end

  // Output Logic
  always @(posedge clk) begin
    if (reset) begin
      counting <= 0;
      done <= 0;
    end else begin
      case (current_state)
        IDLE: begin
          counting <= 0;
          done <= 0;
        end
        PATTERN_DETECTED: begin
          counting <= 0;
          done <= 0;
        end
        CAPTURE_DELAY: begin
          counting <= 0;
          done <= 0;
        end
        COUNTING: begin
          if (counter == ((delay + 1'b1) * 1000 - 1)) begin
            count_display <= delay;
          end
          counting <= 1;
          done <= 0;
        end
        DONE: begin
          counting <= 0;
          done <= 1;
        end
      endcase

      if (current_state == COUNTING && counter_zero) begin
        counting <= 0;
        done <= 1;
      end
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      counter <= 0;
    end else if (current_state == COUNTING && counter == ((delay + 1'b1) * 1000 - 1)) begin
      counter <= (delay + 1'b1) * 1000 - 1;
    end else if (current_state == COUNTING && counter > 0) begin
      counter <= counter - 1;
    end else if (current_state == PATTERN_DETECTED) begin
      counter <= (delay + 1'b1) * 1000 - 1;
    end
  end

endmodule