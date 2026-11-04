module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum logic [2:0] {
        S_IDLE   = 3'b000,
        S_1      = 3'b001,
        S_11     = 3'b010,
        S_110    = 3'b011,
        S_1101   = 3'b100
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            start_shifting <= 1'b0;
        end else begin
            current_state <= next_state;
            if (current_state == S_1101) begin
                start_shifting <= 1'b1;
            end
        end
    end

    always_comb begin
        case (current_state)
            S_IDLE: begin
                if (data) next_state = S_1;
                else next_state = S_IDLE;
            end
            S_1: begin
                if (data) next_state = S_11;
                else next_state = S_IDLE;
            end
            S_11: begin
                if (data) next_state = S_11;
                else next_state = S_110;
            end
            S_110: begin
                if (data) next_state = S_1101;
                else next_state = S_IDLE;
            end
            S_1101: begin
                next_state = S_1101; // Remain in S_1101
            end
            default: next_state = S_IDLE;
        endcase
    end

endmodule