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
  localparam IDLE = 0;
  localparam PATTERN_DETECTED = 1;
  localparam CAPTURE_DELAY = 2;
  localparam COUNTING = 3;
  localparam DONE = 4;

  // State Variable
  reg [2:0] current_state;

  // Pattern Detection
  reg [3:0] data_history;
  wire pattern_detected;
  assign pattern_detected = (data_history == 4'b1101);

  // Delay Value
  reg [3:0] delay;
  reg [3:0] delay_bits_received;
  reg [2:0] delay_bit_count;

  // Counter
  reg [12:0] cycle_count; // Enough bits to count up to 15 * 1000
  reg [3:0] current_count;

  // FSM Logic
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      data_history <= 4'b0000;
      delay <= 4'b0000;
      counting <= 0;
      done <= 0;
      cycle_count <= 0;
      current_count <= 4'b0000;
      delay_bits_received <= 4'b0000;
      delay_bit_count <= 3'b000;
    end else begin
      case (current_state)
        IDLE: begin
          data_history <= {data_history[2:0], data};
          if (pattern_detected) begin
            current_state <= PATTERN_DETECTED;
            delay_bit_count <= 3'b000;
            delay_bits_received <= 4'b0000;
          end
        end
        PATTERN_DETECTED: begin
          current_state <= CAPTURE_DELAY;
        end
        CAPTURE_DELAY: begin
          delay_bits_received[3 - delay_bit_count] <= data;
          delay_bit_count <= delay_bit_count + 1;
          if (delay_bit_count == 3'b111) begin
            delay <= delay_bits_received;
            current_state <= COUNTING;
            counting <= 1;
            done <= 0;
            cycle_count <= 0;
            current_count <= delay;
          end
        end
        COUNTING: begin
          if (cycle_count < 13'd999) begin
            cycle_count <= cycle_count + 1;
          end else begin
            cycle_count <= 0;
            if (current_count > 4'b0000) begin
              current_count <= current_count - 1;
            end else begin
              current_state <= DONE;
              counting <= 0;
              done <= 1;
            end
          end
        end
        DONE: begin
          if (ack) begin
            current_state <= IDLE;
            done <= 0;
            data_history <= 4'b0000;
            delay <= 4'b0000;
            current_count <= 4'b0000;
            delay_bits_received <= 4'b0000;
            delay_bit_count <= 3'b000;
          end
        end
        default: current_state <= IDLE;
      endcase
    end
  end

  assign count = current_count;

endmodule