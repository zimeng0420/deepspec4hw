module top_module (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    typedef enum logic [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or negedge aresetn) begin
        if (~aresetn)
            current_state <= S0;  // Asynchronous reset to state S0
        else
            current_state <= next_state;
    end

    // Combinational logic to determine next state and output
    always_comb begin
        // Default assignments (to prevent inferred latches)
        next_state = current_state;
        z = 0;

        case (current_state)
            S0: begin
                if (x)
                    next_state = S1;
                z = 0;
            end

            S1: begin
                if (~x)
                    next_state = S2;
                z = 0;
            end

            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1;  // Sequence "101" detected
                end else begin
                    next_state = S0;
                end
            end

            default: begin
                next_state = S0;  // Default to avoid latches
                z = 0;
            end
        endcase
    end

endmodule