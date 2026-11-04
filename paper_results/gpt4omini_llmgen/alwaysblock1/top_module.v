module top_module(
    input a, 
    input b,
    output out_assign,
    output reg out_alwaysblock
);

// Assign output using assign statement
assign out_assign = a & b;

// Combinational logic for the output using always block
always @(*) begin
    out_alwaysblock = a & b;  // AND operation
end

endmodule