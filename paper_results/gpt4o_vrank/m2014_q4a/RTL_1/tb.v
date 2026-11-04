`timescale 1ns / 1ps

module tb_top_module;
    // Testbench signals
    reg d;
    reg ena;
    wire q;

    // DUT instantiation
    top_module DUT (
        .d(d),
        .ena(ena),
        .q(q)
    );

    // File to save output
    integer file;

    initial begin
        // Open the file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1: Set d to 0 and ena to 1 for 4 clock cycles
        d = 0; ena = 1;
        #10; $fdisplay(file, "scenario: 1, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 1a, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 1b, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 1c, d = %d, ena = %d, q = %d", d, ena, q);

        // Scenario 2: Set d to 1 and ena to 1 for 4 clock cycles
        d = 1; ena = 1;
        #10; $fdisplay(file, "scenario: 2, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 2a, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 2b, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 2c, d = %d, ena = %d, q = %d", d, ena, q);

        // Scenario 3: Set d to 0 and ena to 0 for 4 clock cycles
        d = 0; ena = 0;
        #10; $fdisplay(file, "scenario: 3, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 3a, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 3b, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 3c, d = %d, ena = %d, q = %d", d, ena, q);
        
        // Scenario 4: Set d to 1 and ena to 0 for 4 clock cycles
        d = 1; ena = 0;
        #10; $fdisplay(file, "scenario: 4, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 4a, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 4b, d = %d, ena = %d, q = %d", d, ena, q);
        #10; $fdisplay(file, "scenario: 4c, d = %d, ena = %d, q = %d", d, ena, q);
        
        // Scenario 5: Cycle ena from 0 to 1 while changing d from 0 to 1 in 3 clock cycles
        d = 0; ena = 0;
        #10; $fdisplay(file, "scenario: 5, d = %d, ena = %d, q = %d", d, ena, q);
        d = 1; ena = 1;
        #10; $fdisplay(file, "scenario: 5a, d = %d, ena = %d, q = %d", d, ena, q);
        #10; d = 1; ena = 0;
        #10; $fdisplay(file, "scenario: 5b, d = %d, ena = %d, q = %d", d, ena, q);
        
        // Scenario 6: Set d to 0, then change ena to 1 and hold for 2 clock cycles
        d = 0; ena = 0;
        #10; $fdisplay(file, "scenario: 6, d = %d, ena = %d, q = %d", d, ena, q);
        ena = 1;
        #10; $fdisplay(file, "scenario: 6a, d = %d, ena = %d, q = %d", d, ena, q);
        #10; ena = 0;
        #10; $fdisplay(file, "scenario: 6b, d = %d, ena = %d, q = %d", d, ena, q);
        
        // Scenario 7: Set d to 1, then change ena to 1 for 2 clock cycles
        d = 1; ena = 0;
        #10; $fdisplay(file, "scenario: 7, d = %d, ena = %d, q = %d", d, ena, q);
        ena = 1;
        #10; $fdisplay(file, "scenario: 7a, d = %d, ena = %d, q = %d", d, ena, q);
        #10; d = 0; ena = 0;
        #10; $fdisplay(file, "scenario: 7b, d = %d, ena = %d, q = %d", d, ena, q);

        // Close the file
        $fclose(file);
    end
endmodule
