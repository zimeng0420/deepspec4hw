module top_module (
    input clk,         // Clock input
    input w,          // Input to the first stage of the shift register
    input R,          // Input that dictates loading of the register
    input E,          // Enable input for shifting
    input L,          // Load signal to control the loading of value R
    output reg Q      // Output of the flip-flop stage
);

always @(posedge clk) begin
    if (L) begin
        Q <= R;  // Load the value R
    end else if (E) begin
        Q <= w;  // Shift the input w
    end // Else retain previous value of Q by default
end

endmodule