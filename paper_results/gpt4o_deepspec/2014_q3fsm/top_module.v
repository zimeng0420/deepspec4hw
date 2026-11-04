module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {STATE_A, STATE_B} state_t;
    state_t state, next_state;

    // Internal signals
    reg [1:0] count;   // Count of w = 1 in the 3-cycle window
    reg [1:0] cycle;   // Current cycle count in 3-cycle evaluation

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Initialize state and internal signals
            state <= STATE_A;
            count <= 0;
            cycle <= 0;
            z <= 0;
        end else begin
            // State transition
            state <= next_state;

            // In state B, update cycle, count, and z
            if (state == STATE_B) begin
                cycle <= cycle + 1;
                if (w)
                    count <= count + 1;

                // After 3 cycles, evaluate z and reset cycle and count
                if (cycle == 2'b10) begin
                    z <= (count == 2);
                    cycle <= 0;
                    count <= 0;
                end else begin
                    z <= 0;
                end
            end else begin
                z <= 0; // z is 0 in state A
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: next_state = (s == 1) ? STATE_B : STATE_A;
            STATE_B: next_state = STATE_B; // Remain in state B
            default: next_state = STATE_A;
        endcase
    end

endmodule