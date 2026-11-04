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
    
    typedef enum reg [2:0] {IDLE, S1, S2, S3, SHIFT, COUNTING, DONE} state_t;
    state_t current_state, next_state;
    
    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    // Next state and output logic
    always @* begin
        // Default output
        shift_ena = 0;
        counting = 0;
        done = 0;
        
        case (current_state)
            IDLE: begin
                if (data) 
                    next_state = S1; // Detect first bit of 1101
                else 
                    next_state = IDLE;
            end
            
            S1: begin
                if (data) 
                    next_state = S2; // Detect second bit of 1101
                else 
                    next_state = IDLE;
            end
            
            S2: begin
                if (~data) 
                    next_state = S3; // Detect third bit of 1101
                else 
                    next_state = IDLE;
            end
            
            S3: begin
                if (~data) 
                    next_state = SHIFT; // Detect fourth bit of 1101
                else 
                    next_state = IDLE;
            end
            
            SHIFT: begin
                shift_ena = 1;
                next_state = COUNTING; // Move to counting state after 4 cycles
            end
            
            COUNTING: begin
                counting = 1;
                if (done_counting) 
                    next_state = DONE;
                else 
                    next_state = COUNTING; // Stay in counting until done_counting is high
            end
            
            DONE: begin
                done = 1;
                if (ack) 
                    next_state = IDLE; // Acknowledge and reset to IDLE
                else 
                    next_state = DONE; // Stay in done until ack received
            end
            
            default: next_state = IDLE; // Default case
        endcase
    end

endmodule