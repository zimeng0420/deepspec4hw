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
    parameter IDLE = 0;           // Waiting for start sequence (1101)
    parameter CAPTURE_DELAY = 1;  // Capturing the delay value
    parameter COUNTING = 2;        // Counting down
    parameter DONE_ACK = 3;       // Waiting for acknowledge

    // Internal Signals
    reg [1:0] state;
    reg [3:0] shift_reg;          // Shift register for start sequence detection
    reg [3:0] delay;             // Delay value
    reg [12:0] counter;           // Counter for clock cycles (1000 cycles/count unit)
    reg [3:0] count_internal;    // Internal counter to output remaining time
    reg [3:0] delay_plus_one;
    reg [3:0] count_target;

    // State Machine Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            shift_reg <= 4'b0000;
            delay <= 4'b0000;
            counter <= 0;
            count_internal <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                    end
                end

                CAPTURE_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    delay <= shift_reg[3:0];
                    count_internal <= delay;
                    delay_plus_one <= delay + 1;
                    count_target <= (delay_plus_one * 10) * 100 ;
                    state <= COUNTING;

                end

                COUNTING: begin
                    counting <= 1;
                    if(counter == count_target - 1) begin
                        state <= DONE_ACK;
                        done <= 1;
                        counting <= 0;
                    end
                   else begin
                       counter <= counter + 1;
                   end
                end
                DONE_ACK: begin
                    counting <= 0;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        counter <= 0;
                    end
                end
            endcase
        end
    end
  always @(posedge clk) begin
    if (state == COUNTING) begin
        if(counter % 1000 == 999 && count_internal > 0) begin
            count_internal <= count_internal - 1;
        end
    end else if (state == IDLE) begin
        count_internal <= 4'b0000; //reset if no counting
    end
  end

    // Output Assignment
    assign count = (counting) ? count_internal : 4'b0000; // Or some don't care value

endmodule