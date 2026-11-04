module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    reg [3:0] pattern_reg;
    reg [3:0] delay;
    reg [11:0] cycle_count;
    reg [3:0] remaining_time;

    parameter IDLE = 0,
              PATTERN_DETECTED = 1,
              READ_DELAY = 2,
              COUNTING = 3,
              DONE = 4;

    reg [2:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0000;
            delay <= 4'b0000;
            cycle_count <= 12'b0;
            remaining_time <= 4'b0000;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= PATTERN_DETECTED;
                    end else begin
                        counting <= 0;
                        done <= 0;
                    end
                end
                PATTERN_DETECTED: begin
                    state <= READ_DELAY;
                end
                READ_DELAY: begin
                    delay[3] <= data;
                    state <= READ_DELAY + 1; 
                end
                READ_DELAY + 1: begin
                    delay[2] <= data;
                    state <= READ_DELAY + 2;
                end
                READ_DELAY + 2: begin
                    delay[1] <= data;
                    state <= READ_DELAY + 3;
                end
                READ_DELAY + 3: begin
                    delay[0] <= data;
                    state <= COUNTING;
                    remaining_time <= delay;
                    cycle_count <= 12'b0;
                    counting <= 1;
                    done <= 0;
                end
                COUNTING: begin
                    if (cycle_count == 12'd999) begin
                        cycle_count <= 12'b0;
                        if (remaining_time == 4'b0000) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            remaining_time <= remaining_time - 1;
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
                        pattern_reg <= 4'b0000;
                        delay <= 4'b0000;
                        cycle_count <= 12'b0;
                        remaining_time <= 4'b0000;
                        done <= 0;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    assign count = (state == COUNTING) ? remaining_time : 4'b0000;

endmodule