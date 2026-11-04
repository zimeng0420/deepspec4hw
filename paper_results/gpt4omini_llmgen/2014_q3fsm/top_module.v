module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// State Encoding
typedef enum reg [1:0] {
    A = 2'b00,  // State A (Reset state)
    B = 2'b01   // State B (Counting state)
} state_t;

state_t current_state, next_state;
reg [2:0] w_counter;  // 3-bit counter for tracking 'w' input
reg [2:0] count_ones; // Counter for number of 1's in 'w'

// Sequential logic for state transitions
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
        count_ones <= 3'b000;
        z <= 0;
        w_counter <= 0;
    end else begin
        current_state <= next_state;
        if (current_state == B) begin
            // Shift current w value into count_ones
            count_ones <= {count_ones[1:0], w};
        end
    end
end

// Combinatorial logic for next state and output
always @(*) begin
    next_state = current_state; // Default to hold state
    z = 0; // Default z to 0

    case (current_state)
        A: begin
            if (s) begin
                next_state = B; // Move to State B when s=1
                count_ones = 3'b000; // Reset counter
                w_counter = 0; // Reset w_counter
            end
        end
        B: begin
            if (w_counter < 3) begin
                w_counter = w_counter + 1; // Increment counter on each clock cycle
            end else begin
                // After 3 clock cycles, check if there are exactly 2 ones
                if (count_ones[0] + count_ones[1] + count_ones[2] == 2) begin
                    z = 1; // Set z to 1 if there are exactly 2 ones
                end
                w_counter = 0; // Reset counter for next set of checks
            end
        end
        default: begin
            next_state = A; // Default case
        end
    endcase
end

endmodule