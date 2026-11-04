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
    // Intermediate wires for AND gate outputs
    wire AND1, AND2, AND3, AND4;

    // AND gates for output p1y
    assign AND1 = p1a & p1b & p1c;
    assign AND2 = p1d & p1e & p1f;
    
    // OR gate for output p1y
    assign p1y = AND1 | AND2;

    // AND gates for output p2y
    assign AND3 = p2a & p2b;
    assign AND4 = p2c & p2d;
    
    // OR gate for output p2y
    assign p2y = AND3 | AND4;
endmodule