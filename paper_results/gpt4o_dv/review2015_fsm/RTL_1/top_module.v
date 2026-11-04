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
    typedef enum reg [2:0] {
        IDLE,
        IDLE_1,
        IDLE_11,
        IDLE_110,
        SHIFT,
        COUNTING,
        DONE
    } state_t;
    
    state_t state, next_state;
    reg [2:0] shift_counter;

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_counter <= 3'b0;
        end else begin
            state <= next_state;
            if (state == SHIFT) begin
                shift_counter <= shift_counter + 1'b1;
            end else begin
                shift_counter <= 3'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = data ? IDLE_1 : IDLE;
            IDLE_1: next_state = data ? IDLE_11 : IDLE;
            IDLE_11: next_state = ~data ? IDLE_110 : IDLE;
            IDLE_110: next_state = data ? SHIFT : IDLE;
            SHIFT: next_state = (shift_counter == 3'b011) ? COUNTING : SHIFT;
            COUNTING: next_state = done_counting ? DONE : COUNTING;
            DONE: next_state = ack ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        shift_ena = (state == SHIFT);
        counting = (state == COUNTING);
        done = (state == DONE);
    end

endmodule