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
  reg [2:0] shift_count;
  reg [3:0] pattern_history;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_ena <= 0;
      counting <= 0;
      done <= 0;
      shift_count <= 0;
      pattern_history <= 4'b0000;
    end else begin
      pattern_history <= {pattern_history[2:0], data}; // Update pattern history

      case (state)
        IDLE: begin
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
          if (pattern_history == 4'b1101) begin
            state <= SHIFT;
            shift_count <= 0;
            shift_ena <= 1;
          end
        end
        SHIFT: begin
          if (shift_count < 3) begin
            shift_ena <= 1;
            shift_count <= shift_count + 1;
          end else begin
            shift_ena <= 0;
            state <= COUNTING;
            counting <= 1;
          end
        end
        COUNTING: begin
          shift_ena <= 0;
          counting <= 1;
          done <= 0;
          if (done_counting) begin
            state <= DONE;
            counting <= 0;
            done <= 1;
          end
        end
        DONE: begin
          shift_ena <= 0;
          counting <= 0;
          done <= 1;
          if (ack) begin
            state <= IDLE;
            done <= 0;
          end
        end
        default: begin
          state <= IDLE;
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
        end
      endcase
    end
  end

endmodule