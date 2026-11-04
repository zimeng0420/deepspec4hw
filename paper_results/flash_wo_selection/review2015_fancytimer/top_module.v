module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

  // State Definition
  localparam IDLE = 0,
             PATTERN_DETECTED = 1,
             CAPTURE_DELAY = 2,
             COUNTING = 3,
             DONE = 4;

  reg [2:0] state;

  // Pattern Detection
  reg [3:0] pattern_shift_reg;
  wire pattern_detected = (pattern_shift_reg == 4'b1101);

  // Delay Capture
  reg [3:0] delay;
  reg [2:0] delay_bit_count;

  // Counter
  reg [11:0] cycle_count; // Counter for 1000 cycles
  reg [3:0] count_reg; // Remaining time (delay value)

  // Internal Signals
  reg counting_enable;

  assign count = (counting) ? count_reg : 4'b0000; // Don't care when not counting

  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      pattern_shift_reg <= 4'b0000;
      delay <= 4'b0000;
      delay_bit_count <= 3'b000;
      cycle_count <= 12'd0;
      count_reg <= 4'b0000;
      counting <= 0;
      done <= 0;
      counting_enable <= 0;
    end else begin
      case (state)
        IDLE: begin
          pattern_shift_reg <= {pattern_shift_reg[2:0], data};
          if (pattern_detected) begin
            state <= PATTERN_DETECTED;
            delay_bit_count <= 3'b000;
          end
        end

        PATTERN_DETECTED: begin
          if (delay_bit_count < 3'd4) begin
            delay[3 - delay_bit_count] <= data;
            delay_bit_count <= delay_bit_count + 3'd1;
          end else begin
            state <= COUNTING;
            count_reg <= delay;
            cycle_count <= 12'd0;
            counting <= 1;
          end
        end

        COUNTING: begin
          if (cycle_count < 12'd999) begin
            cycle_count <= cycle_count + 12'd1;
          end else begin
            cycle_count <= 12'd0;
            if (count_reg > 4'b0000) begin
              count_reg <= count_reg - 4'b0001;
            end else begin
              state <= DONE;
              counting <= 0;
              done <= 1;
            end
          end
        end

        DONE: begin
          if (ack) begin
            state <= IDLE;
            done <= 0;
            pattern_shift_reg <= 4'b0000;
            delay <= 4'b0000;
            delay_bit_count <= 3'b000;
            cycle_count <= 12'd0;
            count_reg <= 4'b0000;
            counting <= 0;
            counting_enable <= 0;
          end
        end

        default: state <= IDLE;
      endcase
    end
  end

endmodule