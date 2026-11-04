module top_module(
	input wire clk,
	input wire reset,
	input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    parameter IDLE = 0;
    parameter S1 = 1;
    parameter S2 = 2;
    parameter S3 = 3;
    parameter LOAD_DELAY = 4;
    parameter COUNTING = 5;
    parameter WAIT_ACK = 6;

    reg [2:0] state;
    reg [3:0] data_in;
    reg [3:0] delay;
    reg [11:0] counter;
    reg [3:0] count_out;
    reg [1:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    bit_count <= 0;
                    if (data == 1) begin
                        state <= S1;
                    end
                end
                S1: begin
                    if (data == 1) begin
                        state <= S2;
                    end else begin
                        state <= IDLE;
                    end
                end
                S2: begin
                    if (data == 0) begin
                        state <= S3;
                    end else begin
                        state <= IDLE;
                    end
                end
                S3: begin
                    if (data == 1) begin
                        state <= LOAD_DELAY;
                        bit_count <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
                LOAD_DELAY: begin
                    data_in[3] <= data;
                    bit_count <= bit_count + 1;
                    if(bit_count == 1)
                    begin
                        data_in[2] <= data;
                    end
                    if(bit_count == 2)
                    begin
                        data_in[1] <= data;
                    end
                    if(bit_count == 3)
                    begin
                        data_in[0] <= data;
                        delay <= data_in;
                        counter <= (delay + 1) * 1000;
                        count_out <= delay;
                        counting <= 1;
                        state <= COUNTING;
                    end
                end
                COUNTING: begin
                    if (counter > 0) begin
                        counter <= counter - 1;
                        if(counter % 1000 == 0 && count_out > 0)
                            count_out <= count_out - 1;

                    end else begin
                        done <= 1;
                        counting <= 0;
                        state <= WAIT_ACK;
                    end
                end
                WAIT_ACK: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

    assign count = count_out;

endmodule