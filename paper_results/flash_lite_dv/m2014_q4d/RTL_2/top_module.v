module top_module (
    input  in,
    input  clk,
    output out
);

    wire xor_out;

    xor #(1) xor_gate (
        .in1(in),
        .in2(out),
        .out(xor_out)
    );

    always @(posedge clk) begin
        out <= xor_out;
    end

endmodule