module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        S_IDLE   = 3'b000,
        S_1      = 3'b001,
        S_11     = 3'b010,
        S_110    = 3'b011,
        S_1101   = 3'b100
    } state_t;

    state_t current_state, next_state;

    // Sequential logic for state transition
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Combinational logic for next state
    always_comb begin
        case (current_state)
            S_IDLE: begin
                if (data) begin
                    next_state = S_1;
                end else begin
                    next_state = S_IDLE;
                end
                start_shifting = 0;
            end
            S_1: begin
                if (data) begin
                    next_state = S_11;
                end else begin
                    next_state = S_IDLE;
                end
                start_shifting = 0;
            end
            S_11: begin
                if (data) begin
                    next_state = S_11;
                end else begin
                    next_state = S_110;
                end
                start_shifting = 0;
            end
            S_110: begin
                if (data) begin
                    next_state = S_1101;
                end else begin
                    next_state = S_IDLE;
                end
                start_shifting = 0;
            end
            S_1101: begin
                start_shifting = 1; // Set output when sequence is detected
                next_state = S_1101; // Remain in this state
            end
            default: begin
                next_state = S_IDLE;
                start_shifting = 0;
            end
        endcase
    end

endmodule