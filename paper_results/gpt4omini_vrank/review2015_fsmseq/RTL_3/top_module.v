module top_module(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

    typedef enum reg [2:0] {
        S0 = 3'b000,
        S1 = 3'b001,
        S2 = 3'b010,
        S3 = 3'b011,
        S4 = 3'b100
    } state_t;

    state_t current_state, next_state;

    always @(posedge clk) begin
        if (reset) 
            current_state <= S0;
        else 
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: begin
                start_shifting = 0;
                if (data) 
                    next_state = S1; 
                else 
                    next_state = S0; 
            end
            S1: begin
                start_shifting = 0;
                if (data) 
                    next_state = S2; 
                else 
                    next_state = S0; 
            end
            S2: begin
                start_shifting = 0;
                if (data) 
                    next_state = S3; 
                else 
                    next_state = S0; 
            end
            S3: begin
                start_shifting = 0;
                if (data) 
                    next_state = S4; 
                else 
                    next_state = S0; 
            end
            S4: begin
                start_shifting = 1; 
                next_state = S4; 
            end
            default: begin
                start_shifting = 0;
                next_state = S0;
            end
        endcase
    end

endmodule