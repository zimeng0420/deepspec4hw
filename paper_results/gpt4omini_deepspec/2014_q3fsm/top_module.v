module top_module (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);
    typedef enum reg [1:0] {A, B} state_t;
    state_t current_state, next_state;
    
    reg [2:0] w_counter; // To count occurrences of w = 1
    reg [2:0] w_history; // To store the last three w values

    // State Transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 0;
            w_counter <= 0;
            w_history <= 3'b000; // Initialize history
        end else begin
            current_state <= next_state;
            // Shift the history of w values
            w_history <= {w_history[1:0], w}; 
            // Update the counter
            if (current_state == B) begin
                w_counter <= w_counter + w; // Count occurrences of w = 1
            end
        end
    end

    // Next State Logic
    always @(*) begin
        case (current_state)
            A: begin
                if (s) begin
                    next_state = B; // Transition to state B
                    w_counter = 0; // Reset counter when moving to state B
                end else begin
                    next_state = A; // Stay in state A
                end
            end
            B: begin
                if (w_history[2] === 1'bx) begin // Check if history is ready
                    next_state = B; // Stay in state B if still collecting
                end else if (w_history[0] + w_history[1] + w_history[2] == 2) begin
                    z = 1; // Set z if exactly two 1's found
                    next_state = B; // Stay in state B
                end else begin
                    z = 0; // Reset z otherwise
                    next_state = B; // Stay in state B
                end
            end
        endcase
    end

endmodule