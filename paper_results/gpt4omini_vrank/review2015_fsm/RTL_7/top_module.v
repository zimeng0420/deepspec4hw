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
        SHIFT_ENA,
        COUNTING,
        DONE
    } state_t;

    state_t current_state, next_state;
    reg [3:0] shift_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_counter <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(current_state or data or done_counting or ack) begin
        case (current_state)
            IDLE: begin
                shift_ena = 0;
                counting = 0;
                done = 0;
                if (data) begin
                    next_state = WAIT_PATTERN;
                end else begin
                    next_state = IDLE;
                end
            end
            
            WAIT_PATTERN: begin
                if ({data, data, data} == 3'b110 && data) begin
                    next_state = SHIFT_ENA;
                end else begin
                    next_state = WAIT_PATTERN;
                end
            end
            
            SHIFT_ENA: begin
                shift_ena = 1;
                shift_counter = shift_counter + 1;
                if (shift_counter == 4) begin
                    shift_counter = 0;
                    next_state = COUNTING;
                end else begin
                    next_state = SHIFT_ENA;
                end
            end
            
            COUNTING: begin
                shift_ena = 0;
                counting = 1;
                if (done_counting) begin
                    next_state = DONE;
                end else begin
                    next_state = COUNTING;
                end
            end
            
            DONE: begin
                counting = 0;
                done = 1;
                if (ack) begin
                    next_state = IDLE;
                end else begin
                    next_state = DONE;
                end
            end
            
            default: next_state = IDLE;
        endcase
    end
endmodule