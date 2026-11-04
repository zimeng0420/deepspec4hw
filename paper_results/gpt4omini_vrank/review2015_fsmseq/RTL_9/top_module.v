module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum logic [2:0] {
        S0 = 3'b000, // Initial state
        S1 = 3'b001, // Got 1
        S2 = 3'b010, // Got 11
        S3 = 3'b011  // Got 110
    } state_t;

    state_t current_state, next_state;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            start_shifting <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    always_ff @(current_state, data) begin
        case (current_state)
            S0: begin
                if (data) 
                    next_state = S1;
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S1: begin
                if (data) 
                    next_state = S2;
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S2: begin
                if (data) 
                    next_state = S3;
                else 
                    next_state = S0;
                start_shifting = 0;
            end
            S3: begin
                next_state = S3; // Remain in S3
                start_shifting = 1; // Found 1101
            end
            default: begin
                next_state = S0;
                start_shifting = 0;
            end
        endcase
    end
endmodule