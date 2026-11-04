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
        S0, // 0 consecutive 1s
        S1, // 1 consecutive 1s
        S2, // 2 consecutive 1s
        S3, // 3 consecutive 1s
        S4, // 4 consecutive 1s
        S5, // 5 consecutive 1s
        S6, // 6 consecutive 1s
        S7  // 7 or more consecutive 1s
    } state_t;
    
    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic and output logic
    always_comb begin
        // Default assignments
        next_state = current_state;
        disc = 1'b0;
        flag = 1'b0;
        err = 1'b0;

        case (current_state)
            S0: next_state = in ? S1 : S0;
            S1: next_state = in ? S2 : S0;
            S2: next_state = in ? S3 : S0;
            S3: next_state = in ? S4 : S0;
            S4: next_state = in ? S5 : S0;
            S5: begin
                if (in) begin
                    next_state = S6;
                end else begin
                    next_state = S0;
                    disc = 1'b1; // 0111110 detected
                end
            end
            S6: begin
                if (in) begin
                    next_state = S7;
                end else begin
                    next_state = S0;
                    flag = 1'b1; // 01111110 detected
                end
            end
            S7: begin
                next_state = in ? S7 : S0;
                err = 1'b1; // 01111111... detected
            end
            default: next_state = S0;
        endcase
    end

endmodule