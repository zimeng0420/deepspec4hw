`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;

    // Outputs
    wire out;

    // Instantiate the DUT
    top_module DUT (
        .a(a), 
        .b(b), 
        .out(out)
    );

    // File descriptor for output
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Test scenarios
        // Scenario 1
        a = 0; b = 0;
        #1; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 1, a = %d, b = %d, out = %d", a, b, out);

        // Scenario 2
        a = 0; b = 1;
        #1; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 2, a = %d, b = %d, out = %d", a, b, out);

        // Scenario 3
        a = 1; b = 0;
        #1; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 3, a = %d, b = %d, out = %d", a, b, out);

        // Scenario 4
        a = 1; b = 1;
        #1; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 4, a = %d, b = %d, out = %d", a, b, out);

        // Close the file
        $fclose(file);

        // End the simulation
        $finish;
    end

endmodule
