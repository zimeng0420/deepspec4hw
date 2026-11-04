module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

  parameter IDLE = 0, START = 1, DATA0 = 2, DATA1 = 3, DATA2 = 4, DATA3 = 5,
            DATA4 = 6, DATA5 = 7, DATA6 = 8, DATA7 = 9, STOP = 10, ERROR = 11;

  reg [3:0] state, next_state;
  reg [7:0] data_reg;
  reg done_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 0;
      done_reg <= 0;
    end else begin
      state <= next_state;
      done_reg <= 0; 
      if (state == DATA7 && next_state == STOP)
        data_reg <= {data_reg[6:0], in};
    end
  end

  always @(*) begin
    next_state = state;
    case (state)
      IDLE: begin
        if (in == 0) begin
          next_state = START;
        end else begin
          next_state = IDLE;
        end
      end
      START: begin
        next_state = DATA0;
      end
      DATA0: begin
        next_state = DATA1;
      end
      DATA1: begin
        next_state = DATA2;
      end
      DATA2: begin
        next_state = DATA3;
      end
      DATA3: begin
        next_state = DATA4;
      end
      DATA4: begin
        next_state = DATA5;
      end
      DATA5: begin
        next_state = DATA6;
      end
      DATA6: begin
        next_state = DATA7;
      end
      DATA7: begin
        next_state = STOP;
      end
      STOP: begin
        if (in == 1) begin
          next_state = IDLE;
          done_reg = 1;
        } else begin
          next_state = ERROR;
        end
      end
      ERROR: begin
        if (in == 1) begin
          next_state = IDLE;
        } else begin
          next_state = ERROR;
        end
      end
      default: next_state = IDLE;
    endcase
  end

  assign out_byte = data_reg;
  assign done = done_reg;

endmodule