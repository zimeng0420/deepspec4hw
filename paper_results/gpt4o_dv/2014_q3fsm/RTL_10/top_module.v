module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01
    } state_t;

    state_t state, next_state;
    reg [1:0] w_count;  // Counts the number of 1s in three cycles
    reg [1:0] cycle_count;  // Counts the current cycle (0 to 2)

    // State transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_A;
            cycle_count <= 2'b00;
            w_count <= 2'b00;
        end else begin
            state <= next_state;
            if (state == STATE_B) begin
                cycle_count <= cycle_count + 1;
                w_count <= w_count + w;
                if (cycle_count == 2'b10) begin  // After 3 cycles
                    z <= (w_count == 2'b10) ? 1'b1 : 1'b0;
                    cycle_count <= 2'b00;
                    w_count <= 2'b00;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            STATE_A: begin
                if (s)
                    next_state = STATE_B;
                else
                    next_state = STATE_A;
            end
            STATE_B: begin
                if (cycle_count == 2'b10)
                    next_state = STATE_B; // Continues in state B
                else
                    next_state = STATE_B;
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule