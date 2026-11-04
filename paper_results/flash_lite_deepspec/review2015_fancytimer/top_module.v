module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State Definitions
    parameter IDLE = 0;
    parameter DETECT = 1;
    parameter CAPTURE = 2;
    parameter COUNTING = 3;
    parameter DONE_STATE = 4;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [15:0] counter; // (delay + 1) * 1000, max delay is 15, so max count is 16000
    reg [15:0] count_internal;
    reg [3:0] count_display;
    wire start_detected;

    // Start Sequence Detection
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 4'b0;
        end else begin
            shift_reg <= {shift_reg[2:0], data};
        end
    end

    assign start_detected = (shift_reg == 4'b1101);

    // State Machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count_internal <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    if (start_detected) begin
                        state <= DETECT;
                    end else begin
                        state <= IDLE;
                    end
                end
                DETECT: begin
                    state <= CAPTURE;
                end
                CAPTURE: begin
                    delay <= shift_reg;
                    count_internal <= (delay + 1) * 1000;
                    state <= COUNTING;
                    counting <= 1;
                end
                COUNTING: begin
                    if (count_internal > 0) begin
                        count_internal <= count_internal - 1;
                        state <= COUNTING;
                    end else begin
                        state <= DONE_STATE;
                        counting <= 0;
                        done <= 1;
                    end
                end
                DONE_STATE: begin
                    counting <= 0;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end else begin
                        state <= DONE_STATE;
                    end
                end
                default: begin
                    state <= IDLE;
                    counting <= 0;
                    done <= 0;
                    count_internal <= 0;
                end
            endcase
        end
    end

    // Count Output
    always @(posedge clk) begin
        if (state == COUNTING) begin
            count_display <= (count_internal / 1000) -1;
        end else begin
            count_display <= 4'b0; // Or don't care, as specified
        end
    end

    assign count = count_display;

endmodule