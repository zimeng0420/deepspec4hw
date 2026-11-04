module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    typedef enum reg [1:0] {A, B, C, D} state_t; // Define the states
    state_t state, next_state;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = (in) ? B : A;
            B: next_state = (in) ? B : C;
            C: next_state = (in) ? D : A;
            D: next_state = (in) ? B : C;
            default: next_state = A; // Default case for safety
        endcase
    end

    // State and output logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A; // Asynchronous reset
            out <= 0;   // Reset output
        end else begin
            state <= next_state; // Update state on clock edge
            out <= (state == D) ? 1 : 0; // Output logic
        end
    end
    
endmodule