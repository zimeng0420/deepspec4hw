module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    reg state, next_state; // state: current state, next_state: next state

    // State encoding
    localparam A = 1'b0, B = 1'b1;

    // Sequential logic for state transitions
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B; // Asynchronously reset to state B
        end else begin
            state <= next_state; // Update current state to next state
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (state)
            A: begin
                next_state = (in == 0) ? B : A; // A transitions
                out = 0; // Output for state A
            end
            B: begin
                next_state = (in == 0) ? A : B; // B transitions
                out = 1; // Output for state B
            end
            default: begin
                next_state = A; // Default state
                out = 0; // Default output
            end
        endcase
    end
endmodule