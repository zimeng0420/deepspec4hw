module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum logic [2:0] {
        S0 = 3'b000, // Initial state, expect a 0
        S1 = 3'b001, // 0
        S2 = 3'b010, // 01
        S3 = 3'b011, // 011
        S4 = 3'b100, // 0111
        S5 = 3'b101, // 01111
        S6 = 3'b110, // 011111
        S7 = 3'b111  // 0111111 (Error state)
    } state_t;

    state_t current_state, next_state;

    // Output logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always_comb begin
        // Default output signals
        disc = 0;
        flag = 0;
        err = 0;
        next_state = current_state;

        case (current_state)
            S0: begin
                if (in == 1) next_state = S1; // Move to S1
            end
            S1: begin
                if (in == 0) next_state = S0; // Back to S0
                else next_state = S2; // Move to S2
            end
            S2: begin
                if (in == 0) next_state = S0; // Back to S0
                else next_state = S3; // Move to S3
            end
            S3: begin
                if (in == 0) next_state = S0; // Back to S0
                else next_state = S4; // Move to S4
            end
            S4: begin
                if (in == 0) next_state = S0; // Back to S0
                else next_state = S5; // Move to S5
            end
            S5: begin
                if (in == 0) next_state = S0; // Back to S0
                else next_state = S6; // Move to S6
            end
            S6: begin
                if (in == 0) begin
                    next_state = S0; // Back to S0
                    flag = 1; // A full flag detected
                end else begin
                    next_state = S7; // Go to Error state
                end
            end
            S7: begin
                if (in == 0) begin
                    next_state = S0; // Back to S0
                    err = 1; // Error condition
                end else begin
                    // Stay in error state
                end
        endcase
        
        // Handle disc signal, when we see 5 consecutive 1s
        if (current_state == S5 && in == 1) begin
            disc = 1; // Signal to discard the next bit
        end
    end

endmodule