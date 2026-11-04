module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    // State declaration
    typedef enum logic [1:0] {
        STATE_A = 2'b00,
        STATE_B = 2'b01,
        STATE_C = 2'b10,
        STATE_D = 2'b11
    } state_t;
    
    state_t current_state, next_state;

    // Counter for w=1 occurrences
    reg [1:0] w_count;
    reg [1:0] cycle_count;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= STATE_A;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic and output logic
    always_comb begin
        // Default values
        next_state = current_state;
        z = 0; // Default output
        w_count = 0;
        case (current_state)
            STATE_A: begin
                if (s)
                    next_state = STATE_B;
            end
            STATE_B: begin
                if (cycle_count < 2) begin
                    w_count = w_count + w;
                    next_state = STATE_B;
                end else begin
                    w_count = w_count + w;
                    if (w_count == 2)
                        z = 1; // Set z to 1 in the following clock cycle

                    next_state = STATE_B; // Continue checking
                end
            end
            default: begin
                next_state = STATE_A;
            end
        endcase
    end

    // Cycle and w-count tracking
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cycle_count <= 0;
            w_count <= 0;
        end else if (current_state == STATE_B) begin
            if (cycle_count < 2) begin
                cycle_count <= cycle_count + 1;
            end else begin
                cycle_count <= 0;
                w_count <= 0;
            end
        end
    end

endmodule