module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum logic [1:0] {
        S0 = 2'b00,
        S1 = 2'b01,
        S2 = 2'b10,
        S3 = 2'b11
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            start_shifting <= 0;
        end else if (current_state == S3) begin
            start_shifting <= 1;
        end
    end

    always_comb begin
        case (current_state)
            S0: begin
                if (data) 
                    next_state = S1;
                else 
                    next_state = S0;
            end
            S1: begin
                if (data) 
                    next_state = S2;
                else 
                    next_state = S0;
            end
            S2: begin
                if (data) 
                    next_state = S3;
                else 
                    next_state = S0;
            end
            S3: begin
                next_state = S3; // Stay in S3
            end
            default: next_state = S0;
        endcase
    end

endmodule