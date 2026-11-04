module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);
    typedef enum logic [2:0] {
        S0 = 3'b000, // Initial state
        S1 = 3'b001, // Received 1
        S2 = 3'b010, // Received 11
        S3 = 3'b011, // Received 110
        S4 = 3'b100  // Received 1101 (final state)
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            S0: begin
                if (data == 1) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (data == 1) next_state = S2;
                else next_state = S0;
            end
            S2: begin
                if (data == 0) next_state = S3;
                else next_state = S2;
            end
            S3: begin
                if (data == 1) begin
                    next_state = S4;
                    start_shifting = 1; // Set output when sequence found
                end else begin
                    next_state = S0;
                end
            end
            S4: begin
                next_state = S4; // Stay in this state if sequence is found
            end
            default: next_state = S0; // Reset to S0 for unrecognized states
        endcase
    end
endmodule