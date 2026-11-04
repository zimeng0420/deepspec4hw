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

    // Define the states using an enum-style declaration for clarity
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        IDLE_1 = 3'b001,
        IDLE_11 = 3'b010,
        IDLE_110 = 3'b011,
        SHIFT = 3'b100,
        COUNTING = 3'b101,
        DONE = 3'b110
    } state_t;

    state_t current_state, next_state;
    reg [1:0] shift_counter; // 2-bit counter to handle the 4 cycles of shift_ena

    // Sequential block: State and counter updates
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            shift_counter <= 2'b00;
        end
        else begin
            current_state <= next_state;

            // Increment shift counter during SHIFT state
            if (current_state == SHIFT)
                shift_counter <= shift_counter + 1'b1;
            else
                shift_counter <= 2'b00; // Reset shift counter otherwise
        end
    end

    // Combinational block: Determine next state
    always @(*) begin
        // Default assignments
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
        endcase
    end

endmodule