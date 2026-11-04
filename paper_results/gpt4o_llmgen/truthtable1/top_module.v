module top_module (
    input x3,
    input x2,
    input x1,
    output f
);

    wire x3_not, x2_not;
    wire term1, term2, term3;

    // NOT gates
    assign x3_not = ~x3;
    assign x2_not = ~x2;

    // AND gates for each minterm
    assign term1 = x3_not & x2;
    assign term2 = x3 & x2_not & x1;
    assign term3 = x3 & x2 & x1;

    // OR gate combining all the minterms
    assign f = term1 | term2 | term3;

endmodule