module top_module (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

assign w = {a, b, c, d}; // Concatenate inputs a, b, c, d for output w
assign x = {e};         // Assign input e to output x
assign y = {f};         // Assign input f to output y
assign z = {2'b11};     // Assign constant value 2'b11 to output z

endmodule