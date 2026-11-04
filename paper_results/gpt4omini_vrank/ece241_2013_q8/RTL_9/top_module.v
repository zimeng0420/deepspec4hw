module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum reg [1:0] {
        S0 = 2'b00, // Initial state
        S1 = 2'b01, // '1' detected
        S2 = 2'b10  // '10' detected
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transition
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= S0;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always @(*) begin
        case (current_state)
            S0: begin
                if (x) begin
                    next_state = S1; // Transition to S1 on '1'
                    z = 1'b0; // Output is low
                end else begin
                    next_state = S0; // Stay in S0
                    z = 1'b0;
                end
            end
            S1: begin
                if (x) begin
                    next_state = S1; // Stay in S1 on '1'
                    z = 1'b0;
                end else begin
                    next_state = S2; // Transition to S2 on '0'
                    z = 1'b0;
                end
            end
            S2: begin
                if (x) begin
                    next_state = S1; // Transition back to S1 on '1'
                    z = 1'b1; // Output is high as "101" is detected
                end else begin
                    next_state = S0; // Go back to S0 on '0'
                    z = 1'b0;
                end
            end
            default: begin
                next_state = S0; // Default case
                z = 1'b0;
            end
        endcase
    end
endmodule