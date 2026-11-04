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
    reg [1:0] w_counter; // Counts occurrences of w = 1
    reg [1:0] cycle_counter; // Counts the number of cycles in STATE_B

    // State transition logic
    always @(posedge clk) begin
        if (reset) begin
            state <= STATE_A;
            w_counter <= 0;
            cycle_counter <= 0;
            z <= 0;
        end
        else begin
            state <= next_state;
            
            if (state == STATE_B) begin
                // Count cycles and occurrences of w = 1
                cycle_counter <= cycle_counter + 1;
                if (w) 
                    w_counter <= w_counter + 1;
                    
                // Check if 3 cycles have passed
                if (cycle_counter == 3) begin
                    z <= (w_counter == 2); // Set z based on w_counter
                    cycle_counter <= 0; // Reset for next 3-cycle window
                    w_counter <= 0; // Reset w_counter
                end
            end else begin
                z <= 0;
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
                next_state = STATE_B; // Stay in STATE_B to evaluate more windows
            end
            default: begin
                next_state = STATE_A; // Default to STATE_A for safety
            end
        endcase
    end

endmodule