module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01
    } state_t;
    state_t state, next_state;

    // Registers to count w occurrences
    reg [1:0] w_count;
    reg [1:0] cycle_count;

    // Sequential block for state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_count <= 0;
            cycle_count <= 0;
            z <= 0;
        end
        else begin
            state <= next_state;
        end
    end

    // Combinational block for next state logic
    always @(*) begin
        next_state = state;  // Default state is to stay in current state
        z = 0;              // Default output is 0
        
        case (state)
            STATE_A: begin
                if (s) begin
                    next_state = STATE_B;
                    w_count = 0;        // Reset count for w occurrences
                    cycle_count = 0;    // Reset cycle count
                end
            end

            STATE_B: begin
                if (cycle_count < 2) begin
                    cycle_count = cycle_count + 1;
                    if (w) begin
                        w_count = w_count + 1;
                    end
                end
                else begin
                    if (w) begin
                        w_count = w_count + 1;
                    end
                    // Check if w occurred exactly twice
                    if (w_count == 2) begin
                        z = 1;
                    end
                    // Reset counting for the next 3 cycles
                    w_count = 0;
                    cycle_count = 0;
                end
            end
        endcase
    end

endmodule