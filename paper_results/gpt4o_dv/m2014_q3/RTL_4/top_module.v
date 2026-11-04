module top_module (
    input [4:1] x,
    output logic f
);

    // Intermediate signals for complemented inputs
    wire x1_not = ~x[1];
    wire x2_not = ~x[2];
    wire x3_not = ~x[3];
    wire x4_not = ~x[4];
    
    // Logic for function f based on the simplified SOP expression
    assign f = (x[3] & x4_not & x[2]) | 
               (x[3] & x4_not & x[1]) | 
               (x[3] & x[4] & x2_not & x1_not) | 
               (x[3] & x[4] & x2_not & x[1]) | 
               (x[3] & x[4] & x[2] & x1_not);

endmodule