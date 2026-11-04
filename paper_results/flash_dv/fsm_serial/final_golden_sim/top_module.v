module top_module (
    input clk,
    input in,
    input reset,
    output done
);

  // Define states
  localparam IDLE      = 3'b000;
  localparam START     = 3'b001;
  localparam DATA      = 3'b010;
  localparam STOP      = 3'b011;
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
            state <= START;
            done <= 0;
          end else begin
            state <= IDLE;
            done <= 0;
          end
        end
        START: begin
          state <= DATA;
          bit_count <= 4'b0;
          data_reg <= 8'b0;
          done <= 0;
        end
        DATA: begin
          data_reg[bit_count] <= in;
          if (bit_count == 4'b0111) begin
            state <= STOP;
            bit_count <= 4'b0;
            done <= 0;
          end else begin
            state <= DATA;
            bit_count <= bit_count + 1'b1;
            done <= 0;
          end
        end
        STOP: begin
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