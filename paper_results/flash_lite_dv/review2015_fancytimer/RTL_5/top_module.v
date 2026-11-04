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
    parameter IDLE = 3'b000;    // Waiting for start sequence
    parameter CAPTURE_DELAY = 3'b001; // Capturing delay value
    parameter COUNTING = 3'b010;  // Counting down
    parameter DONE_WAIT_ACK = 3'b011;  // Timer done, waiting for ack
    parameter DELAY_CALC = 3'b100; // Calculate initial count (used for output)

    // Internal Signals
    reg [2:0] state;
    reg [3:0] shift_reg;       // Shift register for start sequence detection
    reg [3:0] delay;           // Delay value
    reg [3:0] count_internal;  // Internal counter
    reg [12:0] count_cycles;    // Counter for 1000 clock cycles
    reg [3:0] count_output; // Count output register

    // Start Sequence Detection Logic
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 4'b0000;
        else
            shift_reg <= {shift_reg[2:0], data};
    end

    // State Machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 1'b0;
            done <= 1'b0;
            count_output <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    if (shift_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                    end
                end
                CAPTURE_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    delay <= {data,shift_reg[3:1]}; // Capture the delay value
                    state <= DELAY_CALC;
                end
                DELAY_CALC: begin
                    count_output <= delay;
                    state <= COUNTING;
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;

                    if (count_cycles == 1000 - 1) begin
                        count_output <= (count_output > 0) ? count_output - 1'b1: 0;
                        count_cycles <= 0;
                    end else begin
                        count_cycles <= count_cycles + 1'b1;
                    end

                    if (count_output == 0)
                       state <= DONE_WAIT_ACK;
                end

                DONE_WAIT_ACK: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    if (ack)
                        state <= IDLE;
                end
                default:
                    state <= IDLE;
            endcase
        end
    end

    // Output Assignments
    assign count = (counting) ? count_output : 4'b0000; // Don't care when not counting


endmodule