module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State Definition
    localparam IDLE = 0;
    localparam DETECT1 = 1;
    localparam DETECT2 = 2;
    localparam DETECT3 = 3;
    localparam GET_DELAY = 4;
    localparam COUNTING = 5;
    localparam DONE = 6;

    reg [2:0] state;
    reg [3:0] delay;
    reg [11:0] cycle_count;
    reg [3:0] count_reg;

    assign count = count_reg;


    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            cycle_count <= 0;
            count_reg <= 0;
            delay <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    count_reg <= 0;
                    if (data) begin
                        state <= DETECT1;
                    end
                end
                DETECT1: begin
                    if (data) begin
                        state <= DETECT2;
                    end else begin
                        state <= IDLE;
                    end
                end
                DETECT2: begin
                    if (!data) begin
                        state <= DETECT3;
                    end else begin
                        state <= IDLE;
                    end
                end
                DETECT3: begin
                    if (data) begin
                        state <= GET_DELAY;
                    end else begin
                        state <= IDLE;
                    end
                end
                GET_DELAY: begin
                    delay[3] <= data;
                    state <= GET_DELAY_1;
                end
                GET_DELAY_1: begin
                    delay[2] <= data;
                    state <= GET_DELAY_2;
                end
                GET_DELAY_2: begin
                    delay[1] <= data;
                    state <= GET_DELAY_3;
                end
                GET_DELAY_3: begin
                    delay[0] <= data;
                    state <= COUNTING;
                    counting <= 1;
                    cycle_count <= 0;
                    count_reg <= delay;
                end
                COUNTING: begin
                    if (cycle_count < 999) begin
                        cycle_count <= cycle_count + 1;
                    end else begin
                        cycle_count <= 0;
                        if (count_reg > 0) begin
                            count_reg <= count_reg - 1;
                        end else begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        count_reg <= 0;
                    end
                end
                default: begin
                    state <= IDLE;
                    counting <= 0;
                    done <= 0;
                    cycle_count <= 0;
                    count_reg <= 0;
                end
            endcase
        end
    end

endmodule