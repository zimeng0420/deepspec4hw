module top_module(
    input wire clk,
    input wire reset,
    input wire data,
    output wire [3:0] count,
    output reg counting,
    output reg done,
    input wire ack );

    // State Definitions
    localparam IDLE = 0;
    localparam PATTERN_DETECTED = 1;
    localparam SHIFT_DELAY = 2;
    localparam COUNTING = 3;
    localparam DONE = 4;

    // State Variable
    reg [2:0] state;

    // Pattern Detection
    reg [3:0] pattern_shift_reg;

    // Delay Register
    reg [3:0] delay;

    // Counter
    reg [12:0] counter;
    reg [3:0] current_count;

    // FSM Implementation
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_shift_reg <= 4'b0000;
            delay <= 4'b0000;
            counter <= 13'd0;
            current_count <= 4'b0000;
            counting <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_shift_reg <= {pattern_shift_reg[2:0], data};
                    if (pattern_shift_reg == 4'b1101) begin
                        state <= PATTERN_DETECTED;
                    end
                    counting <= 0;
                    done <= 0;
                end
                PATTERN_DETECTED: begin
                    state <= SHIFT_DELAY;
                end
                SHIFT_DELAY: begin
                    delay[3] <= data;
                    state <= SHIFT_DELAY;
                    delay[2] <= data;
                    state <= SHIFT_DELAY;
                    delay[1] <= data;
                    state <= SHIFT_DELAY;
                    delay[0] <= data;

                    state <= COUNTING;
                    counter <= 13'd0;
                    current_count <= delay;
                    counting <= 1;
                end
                COUNTING: begin
                    if (counter < 1000) begin
                        counter <= counter + 1;
                        counting <= 1;
                    end else begin
                        counter <= 13'd0;
                        if (current_count > 4'b0000) begin
                            current_count <= current_count - 1;
                            counting <= 1;
                        end else begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end
                DONE: begin
                    done <= 1;
                    counting <= 0;
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
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

    assign count = current_count;

endmodule