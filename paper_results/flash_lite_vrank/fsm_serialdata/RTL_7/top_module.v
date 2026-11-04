module top_module (
	input clk,
	input in,
	input reset,
	output [7:0] out_byte,
	output done
);

  parameter IDLE = 0, START = 1, DATA = 2, STOP = 3, ERROR = 4;
  reg [2:0] state, next_state;
  reg [7:0] data_reg;
  reg [2:0] bit_count;
  reg done_r;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      done_r <= 0;
      bit_count <= 0;
    end else begin
      state <= next_state;
      done_r <= (next_state == STOP);
    end
  end

  always @(*) begin
    next_state = state;
    out_byte = data_reg;
    case (state)
      IDLE: begin
        done = 0;
        if (!in) begin
          next_state = START;
        end
      end
      START: begin
        done = 0;
        next_state = DATA;
        bit_count = 0;
      end
      DATA: begin
        done = 0;
        data_reg[bit_count] = in;
        bit_count = bit_count + 1;
        if (bit_count == 7) begin
          next_state = STOP;
        end
      end
      STOP: begin
        done = 0;
        if (in) begin
          next_state = IDLE;
        end else begin
          next_state = ERROR;
        end
      end
      ERROR: begin
        done = 0;
        if (in) begin
          next_state = IDLE;
        end
      end
      default: begin
        next_state = IDLE;
        done = 0;
      end
    endcase
  end

  assign done = done_r;

endmodule