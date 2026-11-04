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
            default: out = 8'b00000000; // Default case to handle undefined states
        endcase

        result_is_zero = (out == 8'b00000000); // Check if output is zero
    end

endmodule