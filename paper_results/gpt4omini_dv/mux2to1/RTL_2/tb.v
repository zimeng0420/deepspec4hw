`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;
    reg sel;

    // Outputs
    wire out;

    // Instantiate the DUT
    top_module uut (
        .a(a),
        .b(b),
        .sel(sel),
        .out(out)
    );

    // File handle for exporting data
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Test scenarios
        // Scenario 1
        a = 0; b = 0; sel = 0;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 1, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Scenario 2
        a = 0; b = 0; sel = 1;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 2, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Scenario 3
        a = 0; b = 1; sel = 0;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 3, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Scenario 4
        a = 0; b = 1; sel = 1;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 4, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Scenario 5
        a = 1; b = 0; sel = 0;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 5, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Scenario 6
        a = 1; b = 0; sel = 1;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 6, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Scenario 7
        a = 1; b = 1; sel = 0;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 7, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Scenario 8
        a = 1; b = 1; sel = 1;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 8, a = %d, b = %d, sel = %d, out = %d", a, b, sel, out);

        // Close the file
        $fclose(file);
        
        // End simulation
        $finish;
    end

endmodule
