module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

  reg [3:0] state;
  reg [7:0] data_reg;
  reg done_reg;
  reg [2:0] bit_count;

  localparam IDLE = 0;
  localparam START = 1;
  localparam DATA = 2;
  localparam STOP = 3;
  localparam WAIT_STOP = 4;

  assign out_byte = data_reg;
  assign done = done_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 0;
      done_reg <= 0;
      bit_count <= 0;
    end else begin
      case (state)
        IDLE: begin
          done_reg <= 0;
          if (in == 0) begin
            state <= START;
            bit_count <= 0;
          end
        end
        START: begin
          state <= DATA;
          bit_count <= 0;
        end
        DATA: begin
          data_reg[bit_count] <= in;
          if (bit_count == 7) begin
            state <= STOP;
          end else begin
            bit_count <= bit_count + 1;
          end
        end
        STOP: begin
          if (in == 1) begin
            state <= IDLE;
            done_reg <= 1;
          end else begin
            state <= WAIT_STOP;
            done_reg <= 0;
          end
        end
        WAIT_STOP: begin
          done_reg <= 0;
          if (in == 1) begin
            state <= IDLE;
          end
        end
        default: begin
          state <= IDLE;
          done_reg <= 0;
        end
      endcase
    end
  end

endmodule