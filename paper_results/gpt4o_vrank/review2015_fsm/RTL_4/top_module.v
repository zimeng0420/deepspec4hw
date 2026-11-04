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
        IDLE = 3'b000,
        PATTERN_1 = 3'b001,
        PATTERN_11 = 3'b010,
        PATTERN_110 = 3'b011,
        PATTERN_1101 = 3'b100,
        SHIFTING = 3'b101,
        COUNTING = 3'b110,
        DONE = 3'b111
    } state_t;
    
    state_t state, next_state;
    reg [1:0] shift_counter;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    always @(*) begin
        // Default outputs
        shift_ena = 0;
        counting = 0;
        done = 0;
        next_state = state;
        
        case (state)
            IDLE: begin
                if (data) next_state = PATTERN_1;
            end
            PATTERN_1: begin
                if (data) next_state = PATTERN_11;
                else next_state = IDLE;
            end
            PATTERN_11: begin
                if (!data) next_state = PATTERN_110;
                else next_state = PATTERN_1; // Backtrack
            end
            PATTERN_110: begin
                if (data) next_state = PATTERN_1101;
                else next_state = IDLE;
            end
            PATTERN_1101: begin
                if (data) next_state = SHIFTING;
                else next_state = IDLE;
            end
            SHIFTING: begin
                shift_ena = 1;
                if (shift_counter == 2'b11)
                    next_state = COUNTING;
            end
            COUNTING: begin
                counting = 1;
                if (done_counting)
                    next_state = DONE;
            end
            DONE: begin
                done = 1;
                if (ack)
                    next_state = IDLE;
            end
        endcase
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_counter <= 2'b00;
        end else if (state == SHIFTING) begin
            shift_counter <= shift_counter + 1;
        end else begin
            shift_counter <= 2'b00;
        end
    end
    
endmodule