module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

  // Define states
  localparam IDLE = 3'b000;
  localparam START = 3'b001;
  localparam DATA = 3'b010;
  localparam STOP = 3'b011;
  localparam WAIT_STOP = 3'b100;

  reg [7:0] out_byte_reg;
  reg done_reg;
  reg [2:0] state;
  reg [7:0] data_reg;
  reg [3:0] bit_count;

  assign out_byte = out_byte_reg;
  assign done = done_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      out_byte_reg <= 8'bx;
      done_reg <= 0;
      data_reg <= 8'b0;
      bit_count <= 4'b0;
    end else begin
      case (state)
        IDLE: begin
          if (in == 0) begin
            state <= START;
            done_reg <= 0;
            bit_count <= 4'b0;
          end else begin
            state <= IDLE;
            done_reg <= 0;
          end
        end
        START: begin
          state <= DATA;
        end
        DATA: begin
          data_reg <= {in, data_reg[7:1]};
          if (bit_count == 4'b0111) begin
            state <= STOP;
          end else begin
            state <= DATA;
          end
          bit_count <= bit_count + 1;
        end
        STOP: begin
          if (in == 1) begin
            state <= IDLE;
            out_byte_reg <= data_reg;
            done_reg <= 1;
          } else begin
            state <= WAIT_STOP;
            done_reg <= 0;
          end
        end
        WAIT_STOP: begin
          if (in == 1) begin
            state <= IDLE;
            done_reg <= 0;
          } else begin
            state <= WAIT_STOP;
            done_reg <= 0;
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