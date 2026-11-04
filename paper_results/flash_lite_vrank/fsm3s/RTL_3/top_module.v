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
    reg output_reg;

    // State transition logic
    always @(*) begin
        case (state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A, B, C: output_reg = 1'b0;
            D: output_reg = 1'b1;
            default: output_reg = 1'b0;
        endcase
    end

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

    // Output register
    assign out = output_reg;

endmodule