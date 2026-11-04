module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  parameter IDLE = 0, START = 1, DATA0 = 2, DATA1 = 3, DATA2 = 4, DATA3 = 5,
            DATA4 = 6, DATA5 = 7, DATA6 = 8, DATA7 = 9, STOP = 10, ERROR = 11;

  reg [3:0] state;
  reg done_r;

  assign done = done_r;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      done_r <= 0;
    end else begin
      case (state)
        IDLE: begin
          done_r <= 0;
          if (in == 0) begin
            state <= START;
          end
        end
        START: begin
          state <= DATA0;
        end
        DATA0: begin
          state <= DATA1;
        end
        DATA1: begin
          state <= DATA2;
        end
        DATA2: begin
          state <= DATA3;
        end
        DATA3: begin
          state <= DATA4;
        end
        DATA4: begin
          state <= DATA5;
        end
        DATA5: begin
          state <= DATA6;
        end
        DATA6: begin
          state <= DATA7;
        end
        DATA7: begin
          state <= STOP;
        end
        STOP: begin
          if (in == 1) begin
            state <= IDLE;
            done_r <= 1;
          end else begin
            state <= ERROR;
            done_r <= 0;
          end
        end
        ERROR: begin
          done_r <= 0;
          if (in == 1) begin
            state <= IDLE;
          end
        end
        default: begin
          state <= IDLE;
          done_r <= 0;
        end
      endcase
    end
  end

endmodule