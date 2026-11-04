module top_module (
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);
    // Assigning the selected 4-bit segment from the input array to the output
    assign out = in[(sel * 4) +: 4];
endmodule