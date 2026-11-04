module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);
    
    reg [1:0] current_state, next_state;

    // State encoding
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

    always @(posedge clk) begin
        current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            S0: begin
                state = 0;
                if (a && b) next_state = S1;
                else if (a && !b) next_state = S2;
                else next_state = S0;
            end
            S1: begin
                state = 0;
                next_state = S1;
                q = 1;
            end
            S2: begin
                state = 0;
                next_state = S3;
                q = 1;
            end
            S3: begin
                state = 1;
                if (!a && !b) next_state = S0;
                else next_state = S1;
            end
            default: next_state = S0;
        endcase
    end
    
endmodule