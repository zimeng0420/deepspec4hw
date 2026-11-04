module top_module (
    input clk,
    input j,
    input k,
    input reset,
    output reg out
);

// State Encoding
typedef enum logic [1:0] {
    OFF = 2'b00, // State when output is 0
    ON  = 2'b01  // State when output is 1
} state_t;

state_t current_state, next_state;

// Sequential Logic (State Transition)
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= OFF; // Reset to OFF state
    end else begin
        current_state <= next_state; // Transition to next state
    end
end

// Combinational Logic (Next State Logic)
always_comb begin
    case (current_state)
        OFF: begin
            if (j == 1'b1) begin
                next_state = ON; // Transition to ON state
            end else begin
                next_state = OFF; // Stay in OFF state
            end
        end
        
        ON: begin
            if (k == 1'b1) begin
                next_state = OFF; // Transition to OFF state
            end else begin
                next_state = ON; // Stay in ON state
            end
        end
        
        default: begin
            next_state = OFF; // Default to OFF state in case of unpredictability
        end
    endcase
end

// Output Logic (Moore Output)
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= 1'b0; // Output is 0 when reset
    end else begin
        out <= (current_state == ON) ? 1'b1 : 1'b0; // Output based on current state
    end
end

endmodule