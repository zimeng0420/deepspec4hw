module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum reg [2:0] {
        S0, // Initial state
        S1, // Received 1
        S2, // Received 11
        S3, // Received 110
        S4  // Received 1101
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
            if (next_state == S4) begin
                start_shifting <= 1;
            end
        end
    end

    always @(*) begin
        case (current_state)
            S0: begin
                if (data) next_state = S1; // input 1
                else next_state = S0; // input 0
            end
            S1: begin
                if (data) next_state = S2; // input 1
                else next_state = S0; // input 0
            end
            S2: begin
                if (data) next_state = S3; // input 1
                else next_state = S0; // input 0
            end
            S3: begin
                if (data) next_state = S4; // input 1
                else next_state = S0; // input 0
            end
            S4: begin
                next_state = S4; // stay in S4 indefinitely
            end
            default: next_state = S0; // default state
        endcase
    end

endmodule