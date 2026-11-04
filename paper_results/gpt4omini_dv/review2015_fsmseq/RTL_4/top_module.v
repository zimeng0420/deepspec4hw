module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State encoding
    typedef enum logic [2:0] {
        S_IDLE  = 3'b000,
        S_1     = 3'b001,
        S_11    = 3'b010,
        S_110   = 3'b011,
        S_1101  = 3'b100
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            S_IDLE: begin
                if (data) 
                    next_state = S_1;
                else 
                    next_state = S_IDLE;
            end
            S_1: begin
                if (data) 
                    next_state = S_11;
                else 
                    next_state = S_IDLE;
            end
            S_11: begin
                if (data) 
                    next_state = S_11; // Stay in S_11 if data is '1'
                else 
                    next_state = S_110;
            end
            S_110: begin
                if (data) 
                    next_state = S_1101;
                else 
                    next_state = S_IDLE;
            end
            S_1101: begin
                next_state = S_1101; // Stay in S_1101, output active
                start_shifting = 1; // Output is high when in S_1101
            end
            default: next_state = S_IDLE;
        endcase
    end

    // Output logic
    always_ff @(posedge clk) begin
        if (reset)
            start_shifting <= 0;
        else if (current_state == S_1101)
            start_shifting <= 1;
    end

endmodule