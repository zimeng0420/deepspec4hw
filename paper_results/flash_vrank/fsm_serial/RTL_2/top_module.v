module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  reg [3:0] state;
  reg done_r;

  localparam IDLE = 0;
  localparam START = 1;
  localparam DATA0 = 2;
  localparam DATA1 = 3;
  localparam DATA2 = 4;
  localparam DATA3 = 5;
  localparam DATA4 = 6;
  localparam DATA5 = 7;
  localparam DATA6 = 8;
  localparam DATA7 = 9;
  localparam STOP = 10;
  localparam WAIT_STOP = 11;

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
          end else begin
            state <= IDLE;
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
            state <= WAIT_STOP;
            done_r <= 0;
          end
        end
        WAIT_STOP: begin
          done_r <= 0;
          if (in == 1) begin
            state <= IDLE;
          end else begin
            state <= WAIT_STOP;
          end
        end
        default: begin
          state <= IDLE;
          done_r <= 0;
        end
      endcase
    end
  end

  assign done = done_r;

endmodule