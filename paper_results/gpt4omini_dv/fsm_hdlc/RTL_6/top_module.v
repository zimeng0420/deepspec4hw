module top_module (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000, // Initial state (previous input is assumed 0)
        S1 = 3'b001, // Received 0
        S2 = 3'b010, // Received 1
        S3 = 3'b011, // Received 11
        S4 = 3'b100, // Received 111
        S5 = 3'b101, // Received 1111
        S6 = 3'b110, // Received 11111
        S7 = 3'b111  // Received 111111
    } state_t;

    state_t state, next_state;

    // State transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        disc = 0;
        flag = 0;
        err = 0;

        case (state)
            S0: begin
                if (in) next_state = S1; // Transition to S1 on receiving 1
            end
            S1: begin
                if (in) next_state = S2; // Transition to S2 on receiving 1
                else next_state = S0;    // Transition back to S0 on receiving 0
            end
            S2: begin
                if (in) next_state = S3; // Transition to S3 on receiving 1
                else next_state = S0;    // Transition back to S0 on receiving 0
            end
            S3: begin
                if (in) next_state = S4; // Transition to S4 on receiving 1
                else next_state = S0;    // Transition back to S0 on receiving 0
            end
            S4: begin
                if (in) next_state = S5; // Transition to S5 on receiving 1
                else next_state = S0;    // Transition back to S0 on receiving 0
            end
            S5: begin
                if (in) next_state = S6; // Transition to S6 on receiving 1
                else next_state = S0;    // Transition back to S0 on receiving 0
            end
            S6: begin
                if (in) begin
                    next_state = S7;     // Transition to S7 on receiving 1
                    err = 1;             // Set error flag
                end else begin
                    next_state = S0;     // Transition back to S0 on receiving 0
                    disc = 1;            // Discard flag, because 0111110 was seen
                end
            end
            S7: begin
                if (in) begin
                    err = 1;             // Set error flag, still in error state
                end else begin
                    next_state = S0;     // Transition back to S0 on receiving 0
                    disc = 1;            // Discard flag, because 0111110 was seen
                end
                flag = 1;                // Ending frame flag (01111110) is set
            end
        endcase
    end
endmodule