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

  localparam IDLE = 4'b0000;
  localparam START = 4'b0001;
  localparam DATA = 4'b0010;
  localparam STOP = 4'b0011;
  localparam WAIT_STOP = 4'b0100;

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
        end
      endcase
    end
  end

  assign out_byte = data_reg;
  assign done = done_reg;

endmodule