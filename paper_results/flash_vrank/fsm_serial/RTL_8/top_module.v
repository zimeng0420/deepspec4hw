module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  parameter IDLE = 0, START = 1, DATA0 = 2, DATA1 = 3, DATA2 = 4, DATA3 = 5,
            DATA4 = 6, DATA5 = 7, DATA6 = 8, DATA7 = 9, STOP = 10, ERROR = 11;

  reg [3:0] state;
  reg done;
  reg [2:0] data_cnt;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done <= 0;
      data_cnt <= 0;
    end else begin
      case (state)
        IDLE: begin
          done <= 0;
          if (in == 0) begin
            state <= START;
          end
        end
        START: begin
          state <= DATA0;
          data_cnt <= 0;
        end
        DATA0: begin
          state <= DATA1;
          data_cnt <= data_cnt + 1;
        end
        DATA1: begin
          state <= DATA2;
          data_cnt <= data_cnt + 1;
        end
        DATA2: begin
          state <= DATA3;
          data_cnt <= data_cnt + 1;
        end
        DATA3: begin
          state <= DATA4;
          data_cnt <= data_cnt + 1;
        end
        DATA4: begin
          state <= DATA5;
          data_cnt <= data_cnt + 1;
        end
        DATA5: begin
          state <= DATA6;
          data_cnt <= data_cnt + 1;
        end
        DATA6: begin
          state <= DATA7;
          data_cnt <= data_cnt + 1;
        end
        DATA7: begin
          state <= STOP;
          data_cnt <= data_cnt + 1;
        end
        STOP: begin
          if (in == 1) begin
            state <= IDLE;
            done <= 1;
          end else begin
            state <= ERROR;
            done <= 0;
          end
        end
        ERROR: begin
          done <= 0;
          if (in == 1) begin
            state <= IDLE;
          end
        end
        default: begin
          state <= IDLE;
          done <= 0;
        end
      endcase
    end
  end

endmodule