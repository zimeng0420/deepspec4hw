module top_module (
    input in,
    input [1:0] state,
    output reg [1:0] next_state,
    output reg out
);

    // Combinational logic for the state transitions and output logic
    always @(*) begin
        // Default values
        next_state = state; // Assume the state stays the same unless specified
        out = 0;            // Default output

        case (state)
            2'b00: // State A
                begin
                    if (in)
                        next_state = 2'b01; // Go to State B
                    // Output remains 0
                end
            
            2'b01: // State B
                begin
                    if (in)
                        next_state = 2'b01; // Stay in State B
                    else
                        next_state = 2'b10; // Go to State C
                    // Output remains 0
                end
            
            2'b10: // State C
                begin
                    if (in)
                        next_state = 2'b11; // Go to State D
                    else
                        next_state = 2'b00; // Go to State A
                    // Output remains 0
                end
            
            2'b11: // State D
                begin
                    if (in)
                        next_state = 2'b01; // Go to State B
                    else
                        next_state = 2'b10; // Go to State C
                    out = 1; // Output is 1 in State D
                end
            
            default: 
                begin
                    next_state = 2'b00; // Fallback to State A (optional handling)
                    out = 0; // Default output
                end
        endcase
    end
endmodule