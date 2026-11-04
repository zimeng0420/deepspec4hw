module top_module (
    input clk,
    input in,
    output logic out
);

    logic d_in;

    assign d_in = in ^ out;  // XOR gate

    always_ff @(posedge clk) begin
        out <= d_in;  // D flip-flop
    end

endmodule