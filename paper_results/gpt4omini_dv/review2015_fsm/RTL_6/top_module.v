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

    // State encoding
    typedef enum reg [2:0] {
        IDLE, S1, S2, S3, SHIFT, COUNTING, DONE
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) 
            current_state <= IDLE;
        else 
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data == 1'b1) 
                    next_state = S1;
                else 
                    next_state = IDLE;
                shift_ena = 1'b0; counting = 1'b0; done = 1'b0;
            end
            
            S1: begin
                if (data == 1'b1) 
                    next_state = S2;
                else 
                    next_state = IDLE;
                shift_ena = 1'b0; counting = 1'b0; done = 1'b0;
            end
            
            S2: begin
                if (data == 1'b0) 
                    next_state = S3;
                else 
                    next_state = IDLE;
                shift_ena = 1'b0; counting = 1'b0; done = 1'b0;
            end
            
            S3: begin
                if (data == 1'b1) 
                    next_state = SHIFT;
                else 
                    next_state = IDLE;
                shift_ena = 1'b0; counting = 1'b0; done = 1'b0;
            end
            
            SHIFT: begin
                next_state = (shift_ena_count < 4) ? SHIFT : COUNTING; // shift_ena_count needs to be implemented
                shift_ena = 1'b1; counting = 1'b0; done = 1'b0;
            end
            
            COUNTING: begin
                if (done_counting) 
                    next_state = DONE;
                else 
                    next_state = COUNTING;
                shift_ena = 1'b0; counting = 1'b1; done = 1'b0;
            end
            
            DONE: begin
                if (ack) 
                    next_state = IDLE;
                else 
                    next_state = DONE;
                shift_ena = 1'b0; counting = 1'b0; done = 1'b1;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule