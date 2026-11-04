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
        IDLE = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        SHIFT = 3'b100,
        COUNTING = 3'b101,
        DONE = 3'b110
    } state_t;

    state_t current_state, next_state;
    reg [2:0] shift_count; // To count the duration of shift_ena

    // Combinational logic for next state and output logic
    always @(*) begin
        next_state = current_state;
        shift_ena = 0;
        counting = 0;
        done = 0;

        case (current_state)
            IDLE: begin
                if (data == 1'b1) 
                    next_state = S1;
            end
            S1: begin
                if (data == 1'b1) 
                    next_state = S2;
                else 
                    next_state = IDLE;
            end
            S2: begin
                if (data == 1'b0) 
                    next_state = S3;
                else 
                    next_state = IDLE;
            end
            S3: begin
                if (data == 1'b1) 
                    next_state = SHIFT;
                else 
                    next_state = IDLE;
            end
            SHIFT: begin
                shift_ena = 1;
                if (shift_count < 3) 
                    next_state = SHIFT;
                else 
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

    // Sequential logic for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            shift_count <= 0;
        end else begin
            current_state <= next_state;

            if (current_state == SHIFT) begin
                shift_count <= shift_count + 1;
            end else begin
                shift_count <= 0;
            end
        end
    end

endmodule