module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  // Define states
  localparam IDLE = 3'b000;
  localparam START = 3'b001;
  localparam DATA = 3'b010;
  localparam STOP = 3'b011;
  localparam WAIT_STOP = 3'b100;

  // State register
  reg [2:0] state;

  // Data register
  reg [7:0] data_reg;

  // Bit counter
  reg [3:0] bit_count;

  // Done signal
  reg done;

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      data_reg <= 8'b0;
      bit_count <= 4'b0;
      done <= 1'b0;
    end else begin
      case (state)
        IDLE: begin
          if (in == 1'b0) begin
            state <= START;
            done <= 1'b0;
          end else begin
            state <= IDLE;
            done <= 1'b0;
          end
        end
        START: begin
          state <= DATA;
          bit_count <= 4'b0;
          data_reg[0] <= in;
        end
        DATA: begin
          if (bit_count < 4'b0111) begin
            data_reg[bit_count + 1] <= in;
            bit_count <= bit_count + 4'b1;
            state <= DATA;
          end else begin
            state <= STOP;
          end
        end
        STOP: begin
          if (in == 1'b1) begin
            state <= IDLE;
            done <= 1'b1;
          end else begin
            state <= WAIT_STOP;
            done <= 1'b0;
          end
        end
        WAIT_STOP: begin
          if (in == 1'b1) begin
            state <= IDLE;
            done <= 1'b0;
          end else begin
            state <= WAIT_STOP;
            done <= 1'b0;
          end
        end
        default: begin
          state <= IDLE;
          done <= 1'b0;
        end
      endcase
    end
  end

  assign done = (state == STOP) && (in == 1'b1);

endmodule