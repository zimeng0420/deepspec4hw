module top_module (
    input clk,
    input in,
    input reset,
    output out
);

    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    reg [1:0] state, next_state;
    reg out_reg;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = (in == 0) ? A : B;
            B: next_state = (in == 0) ? C : B;
            C: next_state = (in == 0) ? A : D;
            D: next_state = (in == 0) ? C : B;
            default: next_state = A; // Default state
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A, B, C: out_reg = 0;
            D: out_reg = 1;
            default: out_reg = 0; // Default output
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    assign out = out_reg;

endmodule