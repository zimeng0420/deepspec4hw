module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

  // Define states
  localparam IDLE = 0,
             START_BIT = 1,
             DATA_BITS = 2,
             STOP_BIT = 3,
             WAIT_STOP = 4;

  reg [2:0] state;
  reg [7:0] data_reg;
  reg done_reg;
  reg [2:0] bit_count;

  // Output assignments
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
            state <= START_BIT;
            bit_count <= 0;
          end
        end
        START_BIT: begin
          state <= DATA_BITS;
          data_reg <= 0;
          bit_count <= 0;
        end
        DATA_BITS: begin
          data_reg <= {in, data_reg[7:1]}; // LSB first
          bit_count <= bit_count + 1;
          if (bit_count == 7) begin
            state <= STOP_BIT;
          end
        end
        STOP_BIT: begin
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
        default: state <= IDLE;
      endcase
    end
  end

endmodule