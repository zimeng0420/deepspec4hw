module top_module (
    input clk,
    input in,
    output logic out
);

    // Internal signal to hold the XOR output
    logic D;

    // XOR Gate
    always_comb begin
        D = in ^ out;
    end

    // D Flip-Flop
    always_ff @(posedge clk) begin
        out <= D;
    end

endmodule