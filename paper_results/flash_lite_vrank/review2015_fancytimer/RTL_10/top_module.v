module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    parameter IDLE = 0;
    parameter READ_SEQUENCE = 1;
    parameter READ_DELAY = 2;
    parameter COUNTING = 3;
    parameter DONE_ACK = 4;

    reg [2:0] state;
    reg [3:0] sequence_buffer;
    reg [3:0] delay;
    reg [15:0] counter;
    reg [3:0] remaining_time;

    // State machine logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            sequence_buffer <= 4'b0000;
            delay <= 4'b0000;
            counter <= 16'd0;
            remaining_time <= 4'b0000;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    sequence_buffer <= {sequence_buffer[2:0], data};
                    if (sequence_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                    end
                end
                READ_DELAY: begin
                    delay <= {delay[2:0], data};
                    state <= COUNTING;
                    remaining_time <= delay;
                    counter <= 16'd0;
                end
                COUNTING: begin
                    counting <= 1;
                    if (counter == 999) begin
                        if (remaining_time > 0) begin
                           remaining_time <= remaining_time - 1;
                        end
                       counter <= 16'd0;
                    end else begin
                       counter <= counter + 1;
                    end
                    if (remaining_time == 0 && counter == 999) begin
                        state <= DONE_ACK;
                    end
                end
                DONE_ACK: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        remaining_time <= 4'b0000;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign count = remaining_time;

endmodule