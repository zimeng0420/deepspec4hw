module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);

  parameter IDLE = 0,
            S1 = 1,
            S2 = 2,
            S3 = 3,
            SHIFT = 4,
            COUNTING = 5,
            DONE = 6;

  reg [2:0] state;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_ena <= 0;
      counting <= 0;
      done <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (data) begin
            state <= S1;
          end else begin
            state <= IDLE;
          end
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
        end
        S1: begin
          if (data) begin
            state <= S2;
          end else begin
            state <= IDLE;
          end
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
        end
        S2: begin
          if (~data) begin
            state <= S3;
          end else begin
            state <= IDLE;
          end
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
        end
        S3: begin
          if (data) begin
            state <= SHIFT;
            shift_ena <= 1;
          end else begin
            state <= IDLE;
          end
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
        end
        SHIFT: begin
          shift_ena <= 1;
          if (shift_cycle == 3) begin
            state <= COUNTING;
            shift_ena <= 0;
            counting <= 1;
          end else begin
            state <= SHIFT;
            shift_ena <= 1;
          end
          done <= 0;
        end
        COUNTING: begin
          shift_ena <= 0;
          counting <= 1;
          done <= 0;
          if (done_counting) begin
            state <= DONE;
            counting <= 0;
            done <= 1;
          end else begin
            state <= COUNTING;
          end
        end
        DONE: begin
          shift_ena <= 0;
          counting <= 0;
          done <= 1;
          if (ack) begin
            state <= IDLE;
            done <= 0;
          end else begin
            state <= DONE;
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

  reg [1:0] shift_cycle;

  always @(posedge clk) begin
    if (reset) begin
      shift_cycle <= 0;
    end else if (state == SHIFT) begin
      if (shift_cycle == 3) begin
        shift_cycle <= 0;
      end else begin
        shift_cycle <= shift_cycle + 1;
      end
    end else begin
      shift_cycle <= 0;
    end
  end

endmodule