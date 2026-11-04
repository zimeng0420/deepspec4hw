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

    // State transition logic
    always @(*) begin
        case (current_state)
            S0: next_state = (a && b) ? S0 : (a && !b) ? S1 : (!a && b) ? S0 : S0;
            S1: next_state = (!a && b) ? S2 : (!a && !b) ? S0 : S1;
            S2: next_state = (a && b) ? S3 : (a && !b) ? S2 : (!a && b) ? S2 : S0;
            S3: next_state = (!a && b) ? S1 : (a && !b) ? S2 : (a && b) ? S3 : S3;
            default: next_state = S0;
        endcase
    end

    // Flip-flop for state storage
    always @(posedge clk) begin
        current_state <= next_state;
    end

    // Output logic
    always @(current_state) begin
        case (current_state)
            S0: begin
                q = 0;
                state = 0;
            end
            S1: begin
                q = 1;
                state = 0;
            end
            S2: begin
                q = 0;
                state = 1;
            end
            S3: begin
                q = 1;
                state = 1;
            end
            default: begin
                q = 0;
                state = 0;
            end
        endcase
    end
endmodule