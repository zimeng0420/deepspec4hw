module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

  // State definition
  localparam IDLE       = 4'b0000;
  localparam DETECT_1   = 4'b0001;
  localparam DETECT_11  = 4'b0010;
  localparam DETECT_110 = 4'b0011;
  localparam DETECT_1101= 4'b0100;
  localparam LOAD_DELAY_1 = 4'b0101;
  localparam LOAD_DELAY_2 = 4'b0110;
  localparam LOAD_DELAY_3 = 4'b0111;
  localparam LOAD_DELAY_4 = 4'b1000;
  localparam COUNTING   = 4'b1001;
  localparam DONE       = 4'b1010;

  reg [3:0] state;
  reg [3:0] delay;
  reg [11:0] counter; // Enough bits to count up to 15 * 1000 + 1000
  reg [3:0] count_reg;

  assign count = (counting) ? count_reg : 4'bx;

  always @(posedge clk) begin
    if (reset) begin
      state    <= IDLE;
      counting <= 0;
      done     <= 0;
      counter  <= 0;
      delay    <= 0;
      count_reg <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (data) begin
            state <= DETECT_1;
          end
        end
        DETECT_1: begin
          if (data) begin
            state <= DETECT_11;
          end else begin
            state <= IDLE;
          end
        end
        DETECT_11: begin
          if (!data) begin
            state <= DETECT_110;
          end else begin
            state <= IDLE;
          end
        end
        DETECT_110: begin
          if (data) begin
            state <= DETECT_1101;
          end else begin
            state <= IDLE;
          end
        end
        DETECT_1101: begin
          state <= LOAD_DELAY_1;
          delay <= 0;
        end
        LOAD_DELAY_1: begin
          delay[3] <= data;
          state <= LOAD_DELAY_2;
        end
        LOAD_DELAY_2: begin
          delay[2] <= data;
          state <= LOAD_DELAY_3;
        end
        LOAD_DELAY_3: begin
          delay[1] <= data;
          state <= LOAD_DELAY_4;
        end
        LOAD_DELAY_4: begin
          delay[0] <= data;
          state <= COUNTING;
          counting <= 1;
          done <= 0;
          counter <= (delay + 1) * 1000;
          count_reg <= delay;
        end
        COUNTING: begin
          if (counter > 0) begin
            counter <= counter - 1;
            if (counter % 1000 == 0) begin
              count_reg <= count_reg - 1;
            end
          end else begin
            state <= DONE;
            counting <= 0;
            done <= 1;
          end
        end
        DONE: begin
          if (ack) begin
            state <= IDLE;
            done <= 0;
          end
        end
        default: state <= IDLE;
      endcase
    end
  end

endmodule