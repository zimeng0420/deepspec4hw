module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // After 1
        S2, // After 2
        S3, // After 3
        S4, // After 4
        S5, // After 5
        S6, // After 6
        S7  // Error state (7 or more 1s)
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        disc = 0;
        flag = 0;
        err = 0;
        case (current_state)
            S0: begin
                if (in) next_state = S1;
                else next_state = S0;
            end
            S1: begin
                if (in) next_state = S2;
                else next_state = S0;
            end
            S2: begin
                if (in) next_state = S3;
                else next_state = S0;
            end
            S3: begin
                if (in) next_state = S4;
                else next_state = S0;
            end
            S4: begin
                if (in) next_state = S5;
                else next_state = S0;
            end
            S5: begin
                if (in) next_state = S6; // 6 ones
                else begin
                    disc = 1; // 0111110 detected
                    next_state = S0;
                end
            end
            S6: begin
                if (in) begin
                    err = 1; // 01111111 detected
                    next_state = S7;
                end else begin
                    flag = 1; // 01111110 detected
                    next_state = S0;
                end
            end
            S7: begin
                next_state = S7; // Stay in error state
            end
            default: begin
                next_state = S0; // Default case
            end
        endcase
    end
endmodule