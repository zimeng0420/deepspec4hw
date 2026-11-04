module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);
    // State encoding
    typedef enum reg [1:0] {
        B = 1'b0,
        A = 1'b1
    } state_t;
    
    state_t state, next_state;

    // Sequential block to update state on clock edge
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= B; // Reset state is B
        end else begin
            state <= next_state; // Transition to next state
        end
    end

    // Combinational block to determine next state and output
    always @(*) begin
        case (state)
            B: begin
                if (in) begin
                    next_state = B; // Stay in B
                    out = 1; // Output is 1 in state B
                end else begin
                    next_state = A; // Transition to A
                    out = 1; // Output is 1 in state B
                end
            end
            A: begin
                if (in) begin
                    next_state = A; // Stay in A
                    out = 0; // Output is 0 in state A
                end else begin
                    next_state = B; // Transition to B
                    out = 0; // Output is 0 in state A
                end
            end
            default: begin
                next_state = B; // Default to B
                out = 1; // Default output
            end
        endcase
    end
endmodule