module top_module(
    input clk,
    input reset,
    input data,
    output reg shift_ena,
    output reg counting,
    input done_counting,
    output reg done,
    input ack );

    // State encoding
    parameter IDLE = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, SHIFT = 3'b100, COUNTING = 3'b101, DONE = 3'b110;
    
    reg [2:0] state, next_state;
    reg [3:0] shift_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_ena <= 0;
            counting <= 0;
            done <= 0;
            shift_counter <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(state or data or done_counting or ack) begin
        // Default outputs
        shift_ena = 0;
        counting = 0;
        done = 0;
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for pattern 1101
                if ({data, state[2]} == 3'b101) next_state = S1; 
            end
            
            S1: begin
                if ({data, state[1]} == 3'b110) next_state = S2; 
                else next_state = IDLE;
            end
            
            S2: begin
                if ({data, state[0]} == 3'b101) next_state = S3; 
                else next_state = IDLE;
            end
            
            S3: begin
                if (data) begin
                    next_state = SHIFT;
                    shift_counter = 4; // Set counter for shift_ena
                end else begin
                    next_state = IDLE;
                end
            end
            
            SHIFT: begin
                shift_ena = 1;
                if (shift_counter > 0) begin
                    shift_counter = shift_counter - 1; // Decrement counter
                    if (shift_counter == 0) next_state = COUNTING; // Go to counting state after 4 cycles
                end
            end

            COUNTING: begin
                counting = 1;
                if (done_counting) next_state = DONE; // Wait until done_counting is high
            end
            
            DONE: begin
                done = 1;
                if (ack) next_state = IDLE; // Reset state upon ack
            end
            
            default: next_state = IDLE; // Default to IDLE state
        endcase
    end
endmodule