module top_module (
    input clk,
    input in,
    output logic out
);
    logic xor_out;
    logic dff_out;

    // Two-input XOR between 'in' and 'out'
    assign xor_out = in ^ dff_out;

    // D Flip-Flop
    always_ff @(posedge clk) begin
        dff_out <= xor_out;
    end

    // Output assignment
    assign out = dff_out;

endmodule