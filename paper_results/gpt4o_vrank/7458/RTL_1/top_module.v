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

    wire and1, and2, and3, and4;

    // First 3-input AND gate
    assign and1 = p1a & p1b & p1c;

    // Second 3-input AND gate
    assign and2 = p1d & p1e & p1f;

    // OR gate for the first output
    assign p1y = and1 | and2;

    // First 2-input AND gate
    assign and3 = p2a & p2b;

    // Second 2-input AND gate
    assign and4 = p2c & p2d;

    // OR gate for the second output
    assign p2y = and3 | and4;

endmodule