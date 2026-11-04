module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State enumeration: A and B
    typedef enum reg [1:0] {STATE_A, STATE_B} state_t;
    state_t state, next_state;

    reg [1:0] w_count;  // Counter for w=1 occurrences in three cycles
    reg [1:0] cycle_count;  // Counter for three cycles

    // State register update (sequential logic)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_A;
            cycle_count <= 2'b00;
            w_count <= 2'b00;
            z <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STATE_B) begin
                cycle_count <= cycle_count + 1'b1;
                if (w) w_count <= w_count + 1'b1;

                if (cycle_count == 2'b10) begin
                    // After three cycles in state B
                    z <= (w_count == 2'b10);  // Set z if w=1 exactly twice in three cycles
                    cycle_count <= 2'b00;  // Reset cycle counter
                    w_count <= 2'b00;  // Reset w counter
                end
            end else begin
                z <= 1'b0;  // Ensure z is set to 0 in state A
            end
        end
    end

    // Next state logic (combinational logic)
    always @(*) begin
        case (state)
            STATE_A: begin
                if (s)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end

            STATE_B: begin
                next_state = STATE_B;  // Remain in STATE_B
            end

            default: next_state = STATE_A;  // Default state
        endcase
    end

endmodule