module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum logic [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011
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

    always_comb begin
        case (current_state)
            S0: begin
                if (data == 1'b1) 
                    next_state = S1; 
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S1: begin
                if (data == 1'b1) 
                    next_state = S2; 
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S2: begin
                if (data == 1'b0) 
                    next_state = S3; 
                else 
                    next_state = S1;
                start_shifting = 0;
            end
            S3: begin
                if (data == 1'b1) begin
                    next_state = S1;
                    start_shifting = 1;
                end else begin
                    next_state = S0;
                    start_shifting = 0;
                end
            end
            default: begin
                next_state = S0;
                start_shifting = 0;
            end
        endcase
    end

endmodule