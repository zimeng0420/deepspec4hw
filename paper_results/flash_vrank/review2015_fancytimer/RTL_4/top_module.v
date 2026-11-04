module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State definition
    parameter IDLE      = 4'b0001;
    parameter DETECT1   = 4'b0010;
    parameter DETECT2   = 4'b0100;
    parameter DETECT3   = 4'b1000;
    parameter GET_DELAY = 4'b0011;
    parameter COUNTING  = 4'b0101;
    parameter DONE      = 4'b1001;

    reg [3:0] state;
    reg [3:0] delay;
    reg [11:0] cycle_count; // 12 bits needed to count up to 15 * 1000
    reg [3:0] remaining_time;

    assign count = remaining_time;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            delay <= 0;
            cycle_count <= 0;
            remaining_time <= 0;
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
                        state <= GET_DELAY;
                        delay <= 0;
                        remaining_time <= 0;
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
                    remaining_time <= delay;
                end
                COUNTING: begin
                    if (cycle_count < 999) begin
                        cycle_count <= cycle_count + 1;
                        state <= COUNTING;
                        counting <= 1;
                    end else begin
                        cycle_count <= 0;
                        if (remaining_time > 0) begin
                            remaining_time <= remaining_time - 1;
                            state <= COUNTING;
                            counting <= 1;
                        end else begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end
                DONE: begin
                    counting <= 0;
                    done <= 1;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end else begin
                        state <= DONE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Helper states for GET_DELAY
    parameter GET_DELAY_1 = 4'b0110;
    parameter GET_DELAY_2 = 4'b0111;
    parameter GET_DELAY_3 = 4'b1010;

endmodule