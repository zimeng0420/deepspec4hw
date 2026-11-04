`timescale 1ns / 1ps

module testbench;
    // Inputs
    reg a;
    reg b;
    reg c;
    reg d;

    // Outputs
    wire out;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out(out)
    );

    // File handling
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        a = 0; b = 0; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 2
        a = 0; b = 0; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 3
        a = 0; b = 0; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 4
        a = 0; b = 0; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 5
        a = 0; b = 1; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 6
        a = 0; b = 1; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 7
        a = 0; b = 1; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 8
        a = 0; b = 1; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 9
        a = 1; b = 0; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 9, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 10
        a = 1; b = 0; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 10, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 11
        a = 1; b = 0; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 11, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 12
        a = 1; b = 0; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 12, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 13
        a = 1; b = 1; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 13, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 14
        a = 1; b = 1; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 14, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 15
        a = 1; b = 1; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 15, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 16
        a = 1; b = 1; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 16, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Close the output file
        $fclose(file);

        // End the simulation
        $finish;
    end
endmodule
