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

  parameter IDLE = 0;
  parameter BIT1 = 1;
  parameter BIT2 = 2;
  parameter BIT3 = 3;
  parameter SHIFT = 4;
  parameter COUNTING = 5;
  parameter DONE = 6;

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
          shift_ena <= 0;
          counting <= 0;
          done <= 0;
          if (data) begin
            state <= BIT1;
          end else begin
            state <= IDLE;
          end
        end
        BIT1: begin
          if (data) begin
            state <= BIT2;
          end else begin
            state <= IDLE;
          end
        end
        BIT2: begin
          if (!data) begin
            state <= BIT3;
          end else begin
            state <= IDLE;
          end
        end
        BIT3: begin
          if (data) begin
            state <= SHIFT;
            shift_ena <= 1;
          end else begin
            state <= IDLE;
          end
        end
        SHIFT: begin
          shift_ena <= 1;
          if (shift_ena_count == 3) begin
            state <= COUNTING;
            shift_ena <= 0;
            counting <= 1;
          end else begin
            state <= SHIFT;
          end
        end
        COUNTING: begin
          shift_ena <= 0;
          counting <= 1;
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
        default: state <= IDLE;
      endcase
    end
  end

  reg [1:0] shift_ena_count;

  always @(posedge clk) begin
    if (reset) begin
      shift_ena_count <= 0;
    end else begin
      if (state == SHIFT) begin
        if (shift_ena_count == 3'd3) begin
          shift_ena_count <= 0;
        end else begin
          shift_ena_count <= shift_ena_count + 1;
        end
      end else begin
        shift_ena_count <= 0;
      end
    end
  end

endmodule