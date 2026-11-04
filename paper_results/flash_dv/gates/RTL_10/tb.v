`timescale 1ns / 1ps
module tb_top_module;

    // Inputs
    reg a;
    reg b;

    // Outputs
    wire out_and;
    wire out_or;
    wire out_xor;
    wire out_nand;
    wire out_nor;
    wire out_xnor;
    wire out_anotb;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor),
        .out_nand(out_nand),
        .out_nor(out_nor),
        .out_xnor(out_xnor),
        .out_anotb(out_anotb)
    );

    // File descriptor
    integer file;

    initial begin
        // Open file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        a = 0; b = 0;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 1, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb);

        // Scenario 2
        a = 0; b = 1;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 2, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb);

        // Scenario 3
        a = 1; b = 0;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 3, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb);

        // Scenario 4
        a = 1; b = 1;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 4, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb);

        // Scenario 5
        a = 0; b = 0;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 5, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb);

        // Scenario 6
        a = 0; b = 1;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 6, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb);

        // Scenario 7
        a = 1; b = 0;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 7, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb);

        // Scenario 8
        a = 1; b = 1;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 8, a = %d, b = %d, out_and = %d, out_or = %d, out_xor = %d, out_nand = %d, out_nor = %d, out_xnor = %d, out_anotb = %d", a, b, out_and, out_or, out_xnor, out_nand, out_nor, out_xnor, out_anotb);

        // Close file
        $fclose(file);

        // End simulation
        $finish;
    end

endmodule
