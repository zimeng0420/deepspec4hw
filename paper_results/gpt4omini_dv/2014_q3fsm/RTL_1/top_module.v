module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    typedef enum logic [1:0] {
        A = 2'b00, // State A
        B = 2'b01  // State B
    } state_t;

    state_t current_state, next_state;
    logic [2:0] w_count; // Count for w = 1 over three clock cycles
    logic [2:0] w_shift; // Shift register for the last three w values

    // State transition logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 0;
            w_count <= 3'b000;
            w_shift <= 3'b000;
        end else begin
            current_state <= next_state;
            w_shift <= {w_shift[1:0], w}; // Shift the w values
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            A: begin
                if (s) 
                    next_state = B; 
                else 
                    next_state = A; 
            end
            B: begin
                next_state = B; // Remain in state B
            end
            default: next_state = A;
        endcase
    end

    // Counting logic
    always_comb begin
        w_count = w_shift[0] + w_shift[1] + w_shift[2]; // Count number of 1's in last three cycles
    end

    // Output logic
    always_ff @(posedge clk) begin
        if (current_state == B) begin
            if (w_count == 3'b010) // Check if exactly two w's are 1
                z <= 1;
            else 
                z <= 0;
        end
    end

endmodule