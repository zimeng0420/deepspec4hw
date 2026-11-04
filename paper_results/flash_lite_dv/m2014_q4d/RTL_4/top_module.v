module top_module(
    input in,
    input clk,
    output out
);

    wire xor_out;

    xor #(1) xor_gate (
        .in1(in),
        .in2(out),
        .out(xor_out)
    );

    dff dff_inst (
        .d(xor_out),
        .clk(clk),
        .q(out)
    );

endmodule

module dff (
    input d,
    input clk,
    output reg q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule