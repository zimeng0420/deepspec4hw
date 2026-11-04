module top_module (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);
    
    always @(*) begin
        result_is_zero = 0; // Initialize the zero flag to 0
        
        case (do_sub)
            0: out = a + b;
            1: out = a - b;
        endcase

        if (out == 8'b00000000) // Check if output is zero
            result_is_zero = 1;
    end

endmodule