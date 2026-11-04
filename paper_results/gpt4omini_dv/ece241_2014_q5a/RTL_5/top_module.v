module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    typedef enum logic [1:0] {
        S0, // Waiting for the first '1'
        S1  // Inverting bits
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= S0;
            z <= 1'b0; // Initial output reset
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always_comb begin
        case (current_state)
            S0: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b0; // z is not yet valid
                end else begin
                    next_state = S0;
                    z = 1'b1; // 2's complement of 0
                end
            end

            S1: begin
                next_state = S1; // Stay in S1
                z = ~x; // Output the inverted value of x
            end

            default: begin
                next_state = S0;
                z = 1'b0; // Default safe state
            end
        endcase
    end
endmodule