module top_module(
    input clk,
    input areset,
    input x,
    output z
);

    // Define states
    parameter S0 = 0; // Initial state: output = input
    parameter S1 = 1; // Inversion state: output = !input

    // State register
    reg [0:0] current_state, next_state;

    // Flip-flop to store the first '1' encountered.  Used in the state transition logic.
    reg found_one;

    // Combinational logic for next state and output
    always @(*) begin
        case (current_state)
            S0: begin
                // If x is 1, transition to S1 and set found_one to 1.
                if (x) begin
                    next_state = S1;
                    found_one = 1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                // Remain in S1 state
                next_state = S1;
            end
            default: next_state = S0; // Should never happen, but good practice
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        case (current_state)
            S0: z = x;
            S1: z = ~x;
            default: z = 1'b0; // Should never happen, but good practice
        endcase
    end


    // State register update (synchronous)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            found_one <= 1'b0; // Reset found_one as well
        end else begin
            current_state <= next_state;
        end
    end


endmodule