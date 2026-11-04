module top_module (
    input clk,
    input in,
    output logic out
);
    logic d; // internal signal for the D input of the flip-flop

    // Combinational logic: D input of the flip-flop from XOR gate
    assign d = in ^ out;

    // Flip-flop: positive edge triggered
    always_ff @(posedge clk) begin
        out <= d;
    end
endmodule