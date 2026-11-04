module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

  parameter IDLE = 0, START = 1, DATA0 = 2, DATA1 = 3, DATA2 = 4, DATA3 = 5,
            DATA4 = 6, DATA5 = 7, DATA6 = 8, DATA7 = 9, STOP = 10, ERROR = 11;

  reg [3:0] state;
  reg [7:0] data_reg;
  reg done_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 0;
      done_reg <= 0;
    end else begin
      done_reg <= 0; // Default to 0 each clock cycle

      case (state)
        IDLE: begin
          if (in == 0) begin
            state <= START;
          end
        end

        START: begin
          state <= DATA0;
        end

        DATA0: begin
          data_reg[0] <= in;
          state <= DATA1;
        end

        DATA1: begin
          data_reg[1] <= in;
          state <= DATA2;
        end

        DATA2: begin
          data_reg[2] <= in;
          state <= DATA3;
        end

        DATA3: begin
          data_reg[3] <= in;
          state <= DATA4;
        end

        DATA4: begin
          data_reg[4] <= in;
          state <= DATA5;
        end

        DATA5: begin
          data_reg[5] <= in;
          state <= DATA6;
        end

        DATA6: begin
          data_reg[6] <= in;
          state <= DATA7;
        end

        DATA7: begin
          data_reg[7] <= in;
          state <= STOP;
        end

        STOP: begin
          if (in == 1) begin
            state <= IDLE;
            done_reg <= 1;  // Assert done when stop bit is received
          } else begin
            state <= ERROR;
          end
        end

        ERROR: begin
          if (in == 1) begin
            state <= IDLE;
          end
        end

        default: begin
          state <= IDLE;
        end
      endcase
    end
  end

  assign out_byte = data_reg;
  assign done = done_reg;

endmodule