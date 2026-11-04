module top_module (
    input clk,
    input a,
    output reg q
);

    always @(posedge clk) begin
        if (a) begin
            q <= ~q;  // Toggle the output if 'a' is high
        end
    end

endmodule