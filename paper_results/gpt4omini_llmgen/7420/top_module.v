module top_module(
    input p1a, 
    input p1b, 
    input p1c, 
    input p1d, 
    output p1y, 
    input p2a, 
    input p2b, 
    input p2c, 
    input p2d, 
    output p2y
);

    // Internal wires to connect the inputs to the NAND gates
    wire nand1_out;
    wire nand2_out;

    // First 4-input NAND gate
    assign nand1_out = ~(p1a & p1b & p1c & p1d); // NAND operation for inputs p1a, p1b, p1c, p1d
    assign p1y = nand1_out; // Output for the first NAND gate

    // Second 4-input NAND gate
    assign nand2_out = ~(p2a & p2b & p2c & p2d); // NAND operation for inputs p2a, p2b, p2c, p2d
    assign p2y = nand2_out; // Output for the second NAND gate

endmodule