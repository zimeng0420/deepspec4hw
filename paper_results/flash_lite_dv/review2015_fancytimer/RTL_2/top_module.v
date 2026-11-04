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
  parameter IDLE = 2'b00;      // Waiting for start sequence
  parameter CAPTURE_DELAY = 2'b01; // Capturing delay bits
  parameter COUNTING = 2'b10;    // Counting down
  parameter DONE = 2'b11;        // Timer finished, waiting for ACK

  // Internal Signals
  reg [1:0] state;
  reg [3:0] shift_reg;         // Shift register for start sequence detection
  reg [3:0] delay;             // Delay value
  reg [3:0] count_internal;    // Internal counter
  reg [3:0] delay_mult_1000;    // (delay + 1) * 1000, calculated once for performance.
  reg [9:0] counter_1000; // Counter for 1000 cycles

  // Combinational Logic for Calculating delay_mult_1000, only run once.
  always @(*) begin
      delay_mult_1000 = (delay + 1);
  end

  // State Machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      counting <= 1'b0;
      done <= 1'b0;
      count_internal <= 4'b0;
      shift_reg <= 4'b0;
      counter_1000 <= 10'd0;

    end else begin
      case (state)
        IDLE: begin
          counting <= 1'b0;
          done <= 1'b0;
          shift_reg <= {shift_reg[2:0], data};
          if (shift_reg == 4'b1101) begin
            state <= CAPTURE_DELAY;
          end
        end
        CAPTURE_DELAY: begin
          shift_reg <= {shift_reg[2:0], data};
          delay <= shift_reg[3:0];
          state <= COUNTING;
          count_internal <= delay; //Initialize the remaining count
          counter_1000 <= 10'd0;
        end
        COUNTING: begin
          counting <= 1'b1;
          if (counter_1000 == 10'd999) begin
              count_internal <= count_internal - 1;
              counter_1000 <= 10'd0;
          end else begin
              counter_1000 <= counter_1000 + 1;
          end

          if (count_internal == 4'b0) begin
            state <= DONE;
          end
        end
        DONE: begin
          counting <= 1'b0;
          done <= 1'b1;
          if (ack) begin
            state <= IDLE;
          end
        end
      endcase
    end
  end

  // Output Assignments
    always @(*) begin
        if (state == COUNTING) begin
            count = count_internal;
        end
        else begin
            count = 4'b0; // or don't care
        end
    end
endmodule