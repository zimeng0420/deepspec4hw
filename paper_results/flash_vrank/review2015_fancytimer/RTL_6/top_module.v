module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] state;
    reg [3:0] delay;
    reg [11:0] cycle_count;
    reg [3:0] count_value;

    localparam IDLE = 4'b0000;
    localparam BIT1 = 4'b0001;
    localparam BIT2 = 4'b0010;
    localparam BIT3 = 4'b0011;
    localparam GET_DELAY0 = 4'b0100;
    localparam GET_DELAY1 = 4'b0101;
    localparam GET_DELAY2 = 4'b0110;
    localparam GET_DELAY3 = 4'b0111;
    localparam COUNTING = 4'b1000;
    localparam DONE = 4'b1001;

    assign count = count_value;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            delay <= 0;
            cycle_count <= 0;
            count_value <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= BIT1;
                    end
                    counting <= 0;
                    done <= 0;
                end
                BIT1: begin
                    if (data) begin
                        state <= BIT2;
                    end else begin
                        state <= IDLE;
                    end
                end
                BIT2: begin
                    if (!data) begin
                        state <= BIT3;
                    end else begin
                        state <= BIT1;
                    end
                end
                BIT3: begin
                    if (data) begin
                        state <= GET_DELAY0;
                        delay <= 0;
                        cycle_count <= 0;
                        counting <= 0;
                        done <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
                GET_DELAY0: begin
                    delay[3] <= data;
                    state <= GET_DELAY1;
                end
                GET_DELAY1: begin
                    delay[2] <= data;
                    state <= GET_DELAY2;
                end
                GET_DELAY2: begin
                    delay[1] <= data;
                    state <= GET_DELAY3;
                end
                GET_DELAY3: begin
                    delay[0] <= data;
                    state <= COUNTING;
                    counting <= 1;
                    count_value <= delay;

                end
                COUNTING: begin
                    counting <= 1;
                    if (cycle_count == 999) begin
                        if (count_value == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                            cycle_count <= 0;
                        } else begin
                            count_value <= count_value - 1;
                            cycle_count <= 0;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                DONE: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        count_value <= 0;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule