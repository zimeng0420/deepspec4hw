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
    
    typedef enum reg [2:0] {
        IDLE,
        WAIT_PATTERN,
        SHIFT,
        COUNT,
        DONE_STATE
    } state_t;

    state_t state, next_state;
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
                if (data == 1'b1) begin
                    next_state = WAIT_PATTERN;
                end
            end
            
            WAIT_PATTERN: begin
                if (data == 1'b1) begin
                    shift_count[3] = 1; // 1st bit
                end else if (data == 1'b0) begin
                    shift_count[2] = 1; // 2nd bit
                end else if (data == 1'b1) begin
                    shift_count[1] = 1; // 3rd bit
                end else if (data == 1'b0) begin
                    shift_count[0] = 1; // 4th bit
                end
                    
                if (shift_count == 4'b1101) begin
                    next_state = SHIFT;
                end
            end
            
            SHIFT: begin
                shift_ena = 1;
                if (shift_count > 0) begin
                    shift_count = shift_count - 1;
                end else begin
                    next_state = COUNT;
                end
            end
            
            COUNT: begin
                counting = 1;
                if (done_counting) begin
                    next_state = DONE_STATE;
                end
            end
            
            DONE_STATE: begin
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

endmodule