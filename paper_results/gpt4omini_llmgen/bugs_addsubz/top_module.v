module top_module (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    always @(*) begin
        // Compute the output based on the do_sub signal
        if (do_sub == 1) begin
            out = a - b;  // Subtraction
        end else begin
            out = a + b;  // Addition
        end

        // Set the result_is_zero flag based on the output
        result_is_zero = (out == 8'b00000000); // Check if out is zero
    end

endmodule