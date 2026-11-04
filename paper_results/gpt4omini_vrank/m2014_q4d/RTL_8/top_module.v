module top_module (
    input clk,
    input in,
    output logic out
);

    logic d;
    logic out_ff;

    // Instantiate XOR gate
    assign d = in ^ out_ff;

    // D flip-flop
    always_ff @(posedge clk) begin
        out_ff <= d;
    end

    assign out = out_ff;

endmodule