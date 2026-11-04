module top_module(
    input p1a, 
    input p1b, 
    input p1c, 
    input p1d,
    input p1e,
    input p1f,
    output p1y, 
    input p2a, 
    input p2b, 
    input p2c, 
    input p2d, 
    output p2y
);

    wire and1_out, and2_out, and3_out, and4_out;

    // First three-input AND gate for the first output
    assign and1_out = p1a & p1b & p1c;
    
    // Second three-input AND gate for the first output
    assign and2_out = p1d & p1e & p1f;
    
    // First two-input AND gate for the second output
    assign and3_out = p2a & p2b;
    
    // Second two-input AND gate for the second output
    assign and4_out = p2c & p2d;
    
    // OR gates to get final outputs
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;
    
endmodule