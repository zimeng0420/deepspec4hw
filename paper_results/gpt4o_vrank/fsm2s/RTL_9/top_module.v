module top_module (
	input clk,
	input j,
	input k,
	input reset,
	output reg out
);

    // Define state encoding
    typedef enum logic [0:0] {
        OFF = 1'b0,
        ON  = 1'b1
    } state_t;

    // Current and next state variables
    state_t current_state, next_state;

    // Output logic based on current state
    always_comb begin
        out = current_state;
    end

    // State transition logic
    always_comb begin
        case (current_state)
            OFF: next_state = j ? ON : OFF; // Transition based on j
            ON : next_state = k ? OFF : ON; // Transition based on k
        endcase
    end

    // State update on clock edge
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= OFF; // Synchronous reset to OFF
        end else begin
            current_state <= next_state;
        end
    end

endmodule