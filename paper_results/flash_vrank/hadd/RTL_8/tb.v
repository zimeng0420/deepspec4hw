`timescale 1ns / 1ps

module tb_top_module;
    // Inputs
    reg a;
    reg b;

    // Outputs
    wire sum;
    wire cout;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .sum(sum),
        .cout(cout)
    );

    // File pointer for output
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1: Initialize DUT with a = 0, b = 0
        a = 0; b = 0; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 1, a = %d, b = %d, sum = %d, cout = %d", a, b, sum, cout);

        // Scenario 2: Set inputs a = 0, b = 1
        a = 0; b = 1; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 2, a = %d, b = %d, sum = %d, cout = %d", a, b, sum, cout);

        // Scenario 3: Set inputs a = 1, b = 0
        a = 1; b = 0; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 3, a = %d, b = %d, sum = %d, cout = %d", a, b, sum, cout);

        // Scenario 4: Set inputs a = 1, b = 1
        a = 1; b = 1; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 4, a = %d, b = %d, sum = %d, cout = %d", a, b, sum, cout);

        // Close the output file
        $fclose(file);
        $finish; // End simulation
    end
endmodule
