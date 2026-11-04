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

    // State declaration
    typedef enum reg [3:0] {
        IDLE, IDLE_1, IDLE_11, IDLE_110, SHIFT,
        SHIFT_1, SHIFT_2, SHIFT_3, COUNTING, DONE
    } state_t;

    state_t current_state, next_state;
    reg [1:0] shift_counter;

    // Synchronous state transitions and output logic
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 2'b00;
        end else begin
            current_state <= next_state;
            if (current_state == SHIFT || current_state == SHIFT_1 ||
                current_state == SHIFT_2 || current_state == SHIFT_3)
                shift_counter <= shift_counter + 1'b1;
            else
                shift_counter <= 2'b00;
        end
    end

    // Next state logic and output assignments
    always @(*) begin
        // Default values
        next_state = current_state;
        shift_ena = 1'b0;
        counting = 1'b0;
        done = 1'b0;

        case (current_state)
            IDLE: begin
                if (data == 1'b1) 
                    next_state = IDLE_1;
            end
            IDLE_1: begin
                if (data == 1'b1) 
                    next_state = IDLE_11; 
                else 
                    next_state = IDLE; 
            end
            IDLE_11: begin
                if (data == 1'b0) 
                    next_state = IDLE_110; 
                else 
                    next_state = IDLE; 
            end
            IDLE_110: begin
                if (data == 1'b1) 
                    next_state = SHIFT; 
                else 
                    next_state = IDLE; 
            end
            SHIFT: begin
                shift_ena = 1'b1;
                if (shift_counter == 2'b11)
                    next_state = COUNTING;
            end
            COUNTING: begin
                counting = 1'b1;
                if (done_counting) 
                    next_state = DONE;
            end
            DONE: begin
                done = 1'b1;
                if (ack) 
                    next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule