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
    typedef enum reg [2:0] {IDLE, S1, S2, S3, SHIFT, COUNTING, DONE} state_t;
    state_t current_state, next_state;

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data == 1'b1) next_state = S1;
                else next_state = IDLE;
            end
            S1: begin
                if (data == 1'b1) next_state = S2;
                else next_state = IDLE;
            end
            S2: begin
                if (data == 1'b0) next_state = S3;
                else next_state = IDLE;
            end
            S3: begin
                if (data == 1'b1) next_state = SHIFT;
                else next_state = IDLE;
            end
            SHIFT: begin
                if (shift_ena) next_state = COUNTING; // go to counting after 4 cycles
                else next_state = SHIFT;
            end
            COUNTING: begin
                if (done_counting) next_state = DONE;
                else next_state = COUNTING;
            end
            DONE: begin
                if (ack) next_state = IDLE;
                else next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            S1, S2, S3: begin
                shift_ena <= 0;
                counting <= 0;
                done <= 0;
            end
            SHIFT: begin
                shift_ena <= 1;
            end
            COUNTING: begin
                counting <= 1;
                shift_ena <= 0;
            end
            DONE: begin
                done <= 1;
                counting <= 0;
            end
        endcase
    end

endmodule