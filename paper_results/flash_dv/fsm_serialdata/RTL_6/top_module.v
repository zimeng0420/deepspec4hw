module top_module (
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,
    output done
);

  // Define states
  localparam IDLE = 0;
  localparam START_BIT = 1;
  localparam DATA_BITS = 2;
  localparam STOP_BIT = 3;
  localparam WAIT_STOP = 4;

  reg [2:0] state;
  reg [7:0] data_reg;
  reg [2:0] bit_count;
  reg done_reg;

  assign out_byte = data_reg;
  assign done = done_reg;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 0;
      bit_count <= 0;
      done_reg <= 0;
    end else begin
      done_reg <= 0; // Default to no done

      case (state)
        IDLE: begin
          if (in == 0) begin
            state <= START_BIT;
            bit_count <= 0;
          end
        end

        START_BIT: begin
          state <= DATA_BITS;
        end

        DATA_BITS: begin
          data_reg[bit_count] <= in;
          if (bit_count == 7) begin
            state <= STOP_BIT;
          end else begin
            bit_count <= bit_count + 1;
          end
        end

        STOP_BIT: begin
          if (in == 1) begin
            state <= IDLE;
            done_reg <= 1;
          end else begin
            state <= WAIT_STOP;
          end
        end

        WAIT_STOP: begin
          if (in == 1) begin
            state <= IDLE;
            done_reg <= 1;
          end else begin
            state <= WAIT_STOP;
          end
        end

        default: begin
          state <= IDLE;
        end
      endcase
    end
  end

endmodule