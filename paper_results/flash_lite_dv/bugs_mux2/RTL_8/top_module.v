module top_module (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out  // Corrected: output should be reg since assigned in always block
);

    always @(*) begin  // Changed to an always block for assignment to reg
        if (sel) begin
            out = b;
        end else begin
            out = a;
        end
    end

endmodule