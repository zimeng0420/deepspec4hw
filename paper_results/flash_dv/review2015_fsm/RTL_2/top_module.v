module top_module(
    input clk,
    input reset,
    input data,
    input done_counting,
    input ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

  // Define states
  typedef enum logic [2:0] {
    IDLE,
    SHIFT,
    COUNTING,
    DONE
  } state_t;

  reg state;
  reg next_state;
  reg [1:0] shift_count;
  reg [2:0] pattern_buffer;

  // Pattern detection logic
  always @(posedge clk) begin
    if (reset) begin
      pattern_buffer <= 3'b000;
    end else begin
      pattern_buffer <= {pattern_buffer[1:0], data};
    end
  end

  wire pattern_detected = (pattern_buffer == 3'b101) && (data == 1'b1);


  // Next state logic
  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (pattern_detected) begin
          next_state = SHIFT;
        end
      end
      SHIFT: begin
        if (shift_count == 2'b11) begin
          next_state = COUNTING;
        end
      end
      COUNTING: begin
        if (done_counting) begin
          next_state = DONE;
        end
      end
      DONE: begin
        if (ack) begin
          next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end

  // State and shift_count update
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_count <= 2'b00;
      shift_ena <= 1'b0;
      counting <= 1'b0;
      done <= 1'b0;
    } else begin
      state <= next_state;
      if (state == SHIFT) begin
        if (shift_count < 2'b11) begin
          shift_count <= shift_count + 1'b1;
        end else begin
          shift_count <= 2'b00;
        end
      end else begin
        shift_count <= 2'b00;
      end
    end
  end

  // Output logic
  always @(posedge clk) begin
    if(reset) begin
        shift_ena <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        case (state)
          IDLE: begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
          end
          SHIFT: begin
            if (shift_count < 2'b10) begin
              shift_ena <= 1'b1;
            end else begin
              shift_ena <= 1'b0;
            end
            counting <= 1'b0;
            done <= 1'b0;
          end
          COUNTING: begin
            shift_ena <= 1'b0;
            counting <= 1'b1;
            done <= 1'b0;
          end
          DONE: begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b1;
          end
          default: begin
            shift_ena <= 1'b0;
            counting <= 1'b0;
            done <= 1'b0;
          end
        endcase
    end
  end

endmodule