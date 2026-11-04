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
    parameter DONE = 4;

    reg [2:0] state;
    reg [3:0] sequence_buffer;
    reg [3:0] delay;
    reg [3:0] count_internal;
    reg [3:0] remaining_time;
    reg [31:0] counter;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            sequence_buffer <= 4'b0000;
            delay <= 4'b0000;
            count_internal <= 4'b0000;
            remaining_time <= 4'b0000;
            counter <= 32'd0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    sequence_buffer <= {sequence_buffer[2:0], data};
                    if (sequence_buffer == 4'b1101) begin
                        state <= READ_DELAY;
                        counting <= 1'b0;
                        done <= 1'b0;
                    end
                end
                READ_DELAY: begin
                    delay <= {delay[2:0], data};
                    state <= COUNTING;
                    count_internal <= delay;
                    remaining_time <= delay;
                    counter <= 32'd0;
                    counting <= 1'b1;
                    done <= 1'b0;

                end
                COUNTING: begin
                    if (counter < ( { 1'b0, delay } + 1'b1) * 1000 -1 ) begin
                        counter <= counter + 1'b1;
                        remaining_time <= count_internal;
                    end else begin
                        counter <= 32'd0;
                        count_internal <= count_internal - 1'b1;
                        remaining_time <= count_internal;
                        if (count_internal == 4'b0000) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        counting <= 1'b0;
                        done <= 1'b0;
                        sequence_buffer <= 4'b0000;
                        delay <= 4'b0000;
                        count_internal <= 4'b0000;
                        remaining_time <= 4'b0000;
                        counter <= 32'd0;

                    end
                end
            endcase
        end
    end

    assign count = remaining_time;
end