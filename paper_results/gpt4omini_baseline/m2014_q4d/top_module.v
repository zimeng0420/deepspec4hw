module top_module (
    input clk,
    input in,
    output logic out
);

    logic xor_out;
    logic dff_out;

    assign xor_out = in ^ dff_out;

    always_ff @(posedge clk) begin
        dff_out <= xor_out;
    end

    assign out = dff_out;

endmodule