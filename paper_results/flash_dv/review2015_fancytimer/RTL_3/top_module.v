module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack
);

  // State Definitions
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

  // State Register
  reg [3:0] current_state;
  reg [3:0] next_state;

  // Internal Registers
  reg [3:0] delay;
  reg [12:0] counter; // Sufficient bits to count up to 15 * 1000
  reg [3:0] current_count;

  // Combinational Logic for Next State
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (data) next_state = DETECT_1;
        else next_state = IDLE;
      end
      DETECT_1: begin
        if (data) next_state = DETECT_11;
        else next_state = IDLE;
      end
      DETECT_11: begin
        if (!data) next_state = DETECT_110;
        else next_state = IDLE;
      end
      DETECT_110: begin
        if (data) next_state = DETECT_1101;
        else next_state = IDLE;
      end
      DETECT_1101: begin
        next_state = LOAD_DELAY_1;
      end
      LOAD_DELAY_1: begin
        next_state = LOAD_DELAY_2;
      end
      LOAD_DELAY_2: begin
        next_state = LOAD_DELAY_3;
      end
      LOAD_DELAY_3: begin
        next_state = LOAD_DELAY_4;
      end
      LOAD_DELAY_4: begin
        next_state = COUNTING;
      end
      COUNTING: begin
        if (counter == 0) next_state = DONE;
        else next_state = COUNTING;
      end
      DONE: begin
        if (ack) next_state = IDLE;
        else next_state = DONE;
      end
      default: next_state = IDLE;
    endcase
  end

  // Sequential Logic for State Update and Counter
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      counting <= 0;
      done <= 0;
      delay <= 0;
      counter <= 0;
      current_count <= 0;
    end else begin
      current_state <= next_state;

      case (current_state)
        IDLE: begin
          counting <= 0;
          done <= 0;
        end
        DETECT_1101: begin
          delay[3] <= data;
        end
        LOAD_DELAY_1: begin
          delay[3] <= data;
        end
         LOAD_DELAY_2: begin
          delay[2] <= data;
        end
         LOAD_DELAY_3: begin
          delay[1] <= data;
        end
         LOAD_DELAY_4: begin
          delay[0] <= data;
        end
        COUNTING: begin
          counting <= 1;
          done <= 0;
          if (counter > 0) begin
            counter <= counter - 1;
          end
        end
        DONE: begin
          counting <= 0;
          done <= 1;
        end
        default: begin
          counting <= 0;
          done <= 0;
        end
      endcase

      if (current_state == LOAD_DELAY_4 && next_state == COUNTING) begin
        counter <= (delay + 1) * 1000;
        current_count <= delay;
      end else if (current_state == COUNTING && counter % 1000 == 0 && counter > 0) begin
          current_count <= current_count - 1;
      end else if (current_state == IDLE) begin
          current_count <= 0;
      end
    end
  end

  // Output Logic
  assign count = (counting) ? (counter/1000) : 4'bx;

endmodule