module top_module(
    input in,
    input clk,
    output reg out
);

    wire xor_out;

    xor xor1 (
        .in1(in),
        .in2(out),
        .out(xor_out)
    );

    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule