module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack
);
    parameter IDLE = 2'b00, PATTERN_DETECT = 2'b01, SHIFT = 2'b10, COUNTING = 2'b11;
    reg [1:0] state, next_state;
    reg [3:0] shift_count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_count <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (state)
            IDLE: begin
                if (data == 1 && /* previous bit is 1 */) begin
                    // Assume a mechanism to check previous bits
                    next_state = PATTERN_DETECT;
                end
            end
            
            PATTERN_DETECT: begin
                if (data == 1) begin
                    // Check for sequence 1101
                    // Assume we are checking the last 3 bits already obtained
                    next_state = SHIFT;
                end else begin
                    next_state = IDLE; // Reset to search for the pattern again
                end
            end
            
            SHIFT: begin
                shift_ena = 1;
                if (shift_count < 4) begin
                    shift_count = shift_count + 1;
                end else begin
                    next_state = COUNTING;
                    shift_count = 0; // Reset the shift count
                end
            end
            
            COUNTING: begin
                counting = 1;
                if (done_counting) begin
                    next_state = IDLE; // Transition after counting
                    done = 1; // Notify user
                end
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule