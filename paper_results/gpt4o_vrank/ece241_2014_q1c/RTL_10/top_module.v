module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    wire [8:0] sum;
    
    assign sum = {a[7], a} + {b[7], b}; // Add with sign extension
    assign s = sum[7:0];                // Lower 8 bits as result
    assign overflow = sum[8] ^ sum[7];  // Check overflow by sign bit comparison
endmodule