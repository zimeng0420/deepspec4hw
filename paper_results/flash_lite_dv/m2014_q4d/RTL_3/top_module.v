module top_module(
    input in,
    input clk,
    output out
);

    wire xor_out;

    // XOR gate
    xor #(1) xor1 (
        .in1(in),
        .in2(out),
        .out(xor_out)
    );

    // D flip-flop
    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule