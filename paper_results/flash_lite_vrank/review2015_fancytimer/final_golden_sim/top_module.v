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
    parameter READ_SEQUENCE = 1;
    parameter READ_DELAY = 2;
    parameter COUNTING = 3;
    parameter DONE_ACK = 4;

    // Internal Signals
    reg [2:0] state;
    reg [3:0] sequence_buffer;
    reg [3:0] delay;
    reg [11:0] counter;
    reg [3:0] count_internal;
    
    // FSM Logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            counter <= 0;
            sequence_buffer <= 0;
            delay <= 0;
            count_internal <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    sequence_buffer <= {sequence_buffer[1:0], data};
                    if (sequence_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                    end
                end
                READ_DELAY: begin
                    sequence_buffer <= {sequence_buffer[1:0], data};
                    delay <= sequence_buffer[3:0];
                    state <= COUNTING;
                    counter <= 0;
                    count_internal <= delay;
                end
                COUNTING: begin
                    counting <= 1;
                    if (counter < 999) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 0;
                        if (count_internal > 0) begin
                            count_internal <= count_internal - 1;
                        end else begin
                            state <= DONE_ACK;
                            counting <= 0;
                        end
                    end
                end
                DONE_ACK: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

    // Output Assignments
    assign count = (counting) ? count_internal : 4'b0000;


endmodule