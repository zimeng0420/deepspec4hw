module top_module (
    input clk,
    input in,
    output logic out
);

    logic xor_output; // Intermediate signal for the XOR output
    logic d_ff;      // Output of the D flip-flop

    // Two-input XOR operation
    assign xor_output = in ^ d_ff;

    // D flip-flop implementation
    always_ff @(posedge clk) begin
        d_ff <= xor_output; // Update D flip-flop on positive edge of clk
    end

    // Assign output of D flip-flop to output of module
    assign out = d_ff;

endmodule