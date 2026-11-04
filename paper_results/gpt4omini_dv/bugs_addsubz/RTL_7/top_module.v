module top_module (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
            default: out = 8'b0; // Add default case to prevent latches
        endcase

        result_is_zero = (out == 8'b0); // Check if out is zero
    end

endmodule