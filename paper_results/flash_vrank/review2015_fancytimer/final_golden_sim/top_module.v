module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] pattern;
    reg [3:0] delay;
    reg [11:0] counter;
    reg [3:0] count_reg;

    localparam IDLE = 0;
    localparam DETECT1 = 1;
    localparam DETECT2 = 2;
    localparam DETECT3 = 3;
    localparam GET_DELAY0 = 4;
    localparam GET_DELAY1 = 5;
    localparam GET_DELAY2 = 6;
    localparam GET_DELAY3 = 7;
    localparam COUNTING = 8;
    localparam DONE = 9;

    reg [3:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern <= 4'b0000;
            delay <= 4'b0000;
            counter <= 12'd0;
            count_reg <= 4'd0;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern == 4'b1101) begin
                        state <= GET_DELAY0;
                    end
                    counting <= 0;
                    done <= 0;
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
                    count_reg <= delay;
                    counter <= 12'd0;
                end
                COUNTING: begin
                    if (counter < 12'd999) begin
                        counter <= counter + 1;
                    end else begin
                        counter <= 12'd0;
                        if (count_reg > 4'd0) begin
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
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign count = count_reg;

endmodule