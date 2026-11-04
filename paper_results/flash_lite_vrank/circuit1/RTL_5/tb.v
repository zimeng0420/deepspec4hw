`timescale 1ns / 1ps

module tb_top_module;
    // Inputs
    reg a;
    reg b;
    // Outputs
    wire q;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .q(q)
    );

    // File handle for exporting signals
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        a = 0; b = 0; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 1, a = %d, b = %d, q = %d", a, b, q);

        // Scenario 2
        #20; // At time 25ns (0 + 5 + 20 = 25ns)
        a = 0; b = 1; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 2, a = %d, b = %d, q = %d", a, b, q);

        // Scenario 3
        #10; // At time 35ns (25 + 5 + 10 = 35ns)
        a = 1; b = 0; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 3, a = %d, b = %d, q = %d", a, b, q);

        // Scenario 4
        #10; // At time 45ns (35 + 5 + 10 = 45ns)
        a = 1; b = 1; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 4, a = %d, b = %d, q = %d", a, b, q);

        // Scenario 5
        #10; // At time 55ns (45 + 5 + 10 = 55ns)
        a = 0; b = 0; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 5, a = %d, b = %d, q = %d", a, b, q);

        // Scenario 6
        #10; // At time 65ns (55 + 5 + 10 = 65ns)
        a = 0; b = 1; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 6, a = %d, b = %d, q = %d", a, b, q);

        // Scenario 7
        #10; // At time 75ns (65 + 5 + 10 = 75ns)
        a = 1; b = 0; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 7, a = %d, b = %d, q = %d", a, b, q);

        // Scenario 8
        #10; // At time 85ns (75 + 5 + 10 = 85ns)
        a = 1; b = 1; 
        #5;  // Wait for signals to stabilize
        $fdisplay(file, "scenario: 8, a = %d, b = %d, q = %d", a, b, q);

        // Close the file
        $fclose(file);
        $finish;
    end
endmodule
