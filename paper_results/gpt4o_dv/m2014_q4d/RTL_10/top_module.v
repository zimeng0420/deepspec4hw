module top_module (
    input clk,
    input in,
    output logic out
);

    // Always block triggered on the positive edge of the clock
    always @(posedge clk) begin
        out <= in ^ out;  // XOR operation between input and current output
    end

endmodule