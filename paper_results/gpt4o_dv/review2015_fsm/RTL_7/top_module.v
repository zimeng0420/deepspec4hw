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

    typedef enum logic [2:0] {
        IDLE,      // Initial state, looking for the 1101 pattern
        IDLE_1,    // Detected '1'
        IDLE_11,   // Detected '11'
        IDLE_110,  // Detected '110'
        SHIFT,     // Detected '1101', enable shift for 4 cycles
        COUNTING,  // Wait for done_counting
        DONE       // Notify user and wait for ack
    } state_t;

    state_t state, next_state;
    reg [1:0] shift_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            shift_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == SHIFT) shift_count <= shift_count + 1;
            else shift_count <= 2'b00;
        end
    end

    always_comb begin
        // Default outputs
        shift_ena = 0;
        counting = 0;
        done = 0;
        
        case (state)
            IDLE: begin
                if (data) next_state = IDLE_1;
                else next_state = IDLE;
            end
            IDLE_1: begin
                if (data) next_state = IDLE_11;
                else next_state = IDLE;
            end
            IDLE_11: begin
                if (!data) next_state = IDLE_110;
                else next_state = IDLE;
            end
            IDLE_110: begin
                if (data) next_state = SHIFT;
                else next_state = IDLE;
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_count == 2'b11) next_state = COUNTING;
                else next_state = SHIFT;
            end
            COUNTING: begin
                counting = 1;
                if (done_counting) next_state = DONE;
                else next_state = COUNTING;
            end
            DONE: begin
                done = 1;
                if (ack) next_state = IDLE;
                else next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end
endmodule