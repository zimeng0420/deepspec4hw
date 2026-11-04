module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);
    // State encoding
    typedef enum reg [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011
    } state_t;
    
    state_t state, next_state;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            start_shifting <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(state, data) begin
        case (state)
            S0: begin
                if (data) next_state = S1; // 1
                else next_state = S0;
                start_shifting = 0;
            end
            S1: begin
                if (data) next_state = S2; // 1
                else next_state = S0;
                start_shifting = 0;
            end
            S2: begin
                if (data) next_state = S3; // 0
                else next_state = S0;
                start_shifting = 0;
            end
            S3: begin
                if (!data) begin
                    start_shifting = 1; // Sequence 1101 found
                end
                next_state = S3; // stay in S3
            end
            default: begin
                next_state = S0;
                start_shifting = 0;
            end
        endcase
    end
endmodule