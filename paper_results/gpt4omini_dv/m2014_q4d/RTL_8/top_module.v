module top_module (
    input clk,
    input in,
    output logic out
);

    logic d; // Internal signal for D input of the flip-flop

    // Combinational logic: XOR gate
    assign d = in ^ out;

    // D flip-flop behavior
    always_ff @(posedge clk) begin
        out <= d;
    end

endmodule