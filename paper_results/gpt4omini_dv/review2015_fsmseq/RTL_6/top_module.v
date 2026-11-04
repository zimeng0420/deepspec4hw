module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    // State Encoding
    typedef enum reg [2:0] {
        S_IDLE = 3'b000,
        S_1    = 3'b001,
        S_11   = 3'b010,
        S_110  = 3'b011,
        S_1101 = 3'b100
    } state_t;

    // State register
    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) begin
            current_state <= S_IDLE;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == S_1101) begin
                start_shifting <= 1;
            end
        end
    end

    always @(*) begin
        // Default next state
        next_state = current_state;

        case (current_state)
            S_IDLE: begin
                if (data == 1) 
                    next_state = S_1;
            end

            S_1: begin
                if (data == 1) 
                    next_state = S_11;
                else 
                    next_state = S_IDLE;
            end

            S_11: begin
                if (data == 0) 
                    next_state = S_110;
                else 
                    next_state = S_11;
            end
            
            S_110: begin
                if (data == 1) 
                    next_state = S_1101;
                else 
                    next_state = S_IDLE;
            end

            S_1101: begin
                // Stay in S_1101 as long as reset is not asserted
                if (reset) 
                    next_state = S_IDLE;
            end
        endcase
    end
endmodule