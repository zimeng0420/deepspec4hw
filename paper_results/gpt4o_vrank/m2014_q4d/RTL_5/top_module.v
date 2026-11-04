module top_module (
    input clk,
    input in,
    output logic out
);

    logic d; // Internal signal for D flip-flop input

    always_ff @(posedge clk) begin
        out <= d; // Update flip-flop output with current D input
    end

    assign d = in ^ out; // XOR operation

endmodule