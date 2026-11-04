module top_module(
	input clk,
	input reset,
	input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

  // Define states
  localparam IDLE = 0;
  localparam BIT1 = 1;
  localparam BIT2 = 2;
  localparam BIT3 = 3;
  localparam SHIFT = 4;
  localparam COUNTING = 5;
  localparam DONE = 6;

  reg [2:0] state;
  reg [2:0] next_state;
  reg [3:0] shift_count;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      shift_ena <= 0;
      counting <= 0;
      done <= 0;
      shift_count <= 0;
    end else begin
      state <= next_state;
      if (state == SHIFT && shift_count < 4) begin
        shift_ena <= 1;
        shift_count <= shift_count + 1;
      end else begin
        shift_ena <= 0;
      end

      if (state == COUNTING) begin
        counting <= 1;
      end else begin
        counting <= 0;
      end

      if (state == DONE) begin
        done <= 1;
      end else begin
        done <= 0;
      end
    end
  end

  always @(*) begin
    next_state = state; // Default: stay in the same state
    case (state)
      IDLE: begin
        if (data == 1) begin
          next_state = BIT1;
        end
      end
      BIT1: begin
        if (data == 1) begin
          next_state = BIT2;
        end else begin
          next_state = IDLE;
        end
      end
      BIT2: begin
        if (data == 0) begin
          next_state = BIT3;
        end else begin
          next_state = BIT1;
        end
      end
      BIT3: begin
        if (data == 1) begin
          next_state = SHIFT;
          shift_count = 0;
        end else begin
          next_state = IDLE;
        end
      end
      SHIFT: begin
        if (shift_count == 3) begin
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

endmodule