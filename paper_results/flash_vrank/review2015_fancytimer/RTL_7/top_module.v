module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State machine states
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
    reg [3:0] delay;
    reg [11:0] cycle_count; // Counter for 1000 cycles
    reg [3:0] count_remaining; // Tracks the remaining delay values

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            delay <= 0;
            cycle_count <= 0;
            count_remaining <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data) begin
                        state <= DETECT1;
                    end else begin
                        state <= IDLE;
                    end
                    counting <= 0;
                    done <= 0;
                end
                DETECT1: begin
                    if (data) begin
                        state <= DETECT2;
                    end else begin
                        state <= IDLE;
                    end
                end
                DETECT2: begin
                    if (~data) begin
                        state <= DETECT3;
                    end else begin
                        state <= IDLE;
                    end
                end
                DETECT3: begin
                    if (data) begin
                        state <= GET_DELAY0;
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
                    count_remaining <= delay;
                    cycle_count <= 0;
                end
                COUNTING: begin
                    if (cycle_count == 11'd999) begin
                        cycle_count <= 0;
                        if (count_remaining == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        } else begin
                            count_remaining <= count_remaining - 1;
                        end
                    } else begin
                        cycle_count <= cycle_count + 1;
                    end
                end
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end else begin
                        state <= DONE;
                    end
                end
                default: begin
                    state <= IDLE;
                    counting <= 0;
                    done <= 0;
                end
            endcase
        end
    end

    assign count = count_remaining;

endmodule