module top_module(
    input clk,
    input in,
    input areset,
    output out
);

    // State encoding
    parameter A = 2'b00;
    parameter B = 2'b01;
    parameter C = 2'b10;
    parameter D = 2'b11;

    // State register
    reg [1:0] state;

    // Next state logic
    always @(*) begin
        case (state)
            A: state_next = (in) ? B : A;
            B: state_next = (in) ? B : C;
            C: state_next = (in) ? D : A;
            D: state_next = (in) ? B : C;
            default: state_next = A;
        endcase
    end

    // Output logic
    always @(*) begin
        case (state)
            A: out = 1'b0;
            B: out = 1'b0;
            C: out = 1'b0;
            D: out = 1'b1;
            default: out = 1'b0;
        endcase
    end

    // State update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= state_next;
    end

    reg [1:0] state_next;

endmodule