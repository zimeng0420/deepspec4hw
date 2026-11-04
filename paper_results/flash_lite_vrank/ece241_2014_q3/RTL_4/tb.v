`timescale 1ns / 1ps

module tb_top_module;
    // Inputs
    reg c;
    reg d;

    // Outputs
    wire [3:0] mux_in;

    // Instantiate the DUT
    top_module DUT (
        .c(c),
        .d(d),
        .mux_in(mux_in)
    );

    // File pointer for output
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1: Set inputs c = 0 and d = 0
        c = 0; d = 0;
        #1; // Wait for 1 time unit to stabilize
        $fdisplay(file, "scenario: 1, c = %d, d = %d, mux_in = %b", c, d, mux_in);
        
        // Scenario 2: Set inputs c = 0 and d = 1
        c = 0; d = 1;
        #1; // Wait for 1 time unit to stabilize
        $fdisplay(file, "scenario: 2, c = %d, d = %d, mux_in = %b", c, d, mux_in);

        // Scenario 3: Set inputs c = 1 and d = 0
        c = 1; d = 0;
        #1; // Wait for 1 time unit to stabilize
        $fdisplay(file, "scenario: 3, c = %d, d = %d, mux_in = %b", c, d, mux_in);

        // Scenario 4: Set inputs c = 1 and d = 1
        c = 1; d = 1;
        #1; // Wait for 1 time unit to stabilize
        $fdisplay(file, "scenario: 4, c = %d, d = %d, mux_in = %b", c, d, mux_in);

        // Scenario 5: Cycle through all combinations of inputs
        c = 0; d = 0; #1; $fdisplay(file, "scenario: 5a, c = %d, d = %d, mux_in = %b", c, d, mux_in);
        c = 0; d = 1; #1; $fdisplay(file, "scenario: 5b, c = %d, d = %d, mux_in = %b", c, d, mux_in);
        c = 1; d = 0; #1; $fdisplay(file, "scenario: 5c, c = %d, d = %d, mux_in = %b", c, d, mux_in);
        c = 1; d = 1; #1; $fdisplay(file, "scenario: 5d, c = %d, d = %d, mux_in = %b", c, d, mux_in);

        // Scenario 6: Reset inputs to c = 0 and d = 0
        c = 0; d = 0;
        #2; // Wait for 2 time units to stabilize
        $fdisplay(file, "scenario: 6, c = %d, d = %d, mux_in = %b", c, d, mux_in);

        // Close the file
        $fclose(file);
        
        // End simulation
        $finish;
    end
endmodule
