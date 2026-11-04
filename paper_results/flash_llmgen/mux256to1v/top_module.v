module top_module (
    input [1023:0] in,
    input [7:0] sel,
    output [3:0] out
);

    wire [9:0] index; // 10 bits needed to represent 0 to 1023

    assign index = sel * 4; // Calculate the starting index

    assign out = in[index + 3 : index]; // Extract the 4 bits

endmodule