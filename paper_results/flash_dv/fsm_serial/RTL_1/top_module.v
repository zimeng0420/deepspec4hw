module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  // State definitions
  localparam IDLE      = 3'b000;
  localparam START_BIT = 3'b001;
  localparam DATA_BITS = 3'b010;
  localparam STOP_BIT  = 3'b011;
  localparam WAIT_STOP = 3'b100;

  reg [2:0] state;
  reg [7:0] data_reg;
  reg [3:0] bit_count;
  reg done;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 8'b0;
      bit_count <= 4'b0;
      done <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (in == 0) begin
            state <= START_BIT;
            done <= 0;
          end else begin
            state <= IDLE;
            done <= 0;
          end
        end
        START_BIT: begin
          state <= DATA_BITS;
          bit_count <= 4'b0;
          data_reg <= 8'b0;
          done <= 0;
        end
        DATA_BITS: begin
          data_reg[bit_count] <= in;
          if (bit_count == 4'b0111) begin
            state <= STOP_BIT;
            done <= 0;
          end else begin
            state <= DATA_BITS;
            bit_count <= bit_count + 1'b1;
            done <= 0;
          end
        end
        STOP_BIT: begin
          if (in == 1) begin
            state <= IDLE;
            done <= 1;
          end else begin
            state <= WAIT_STOP;
            done <= 0;
          end
        end
        WAIT_STOP: begin
          if (in == 1) begin
            state <= IDLE;
            done <= 0;
          end else begin
            state <= WAIT_STOP;
            done <= 0;
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