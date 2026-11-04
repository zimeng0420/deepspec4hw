`timescale 1ns / 1ps

module testbench;
    // Declare inputs
    reg a;
    reg b;
    reg c;
    reg d;
    // Declare output
    wire out;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out(out)
    );

    integer file;

    initial begin
        // Open file to export signals
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1: (0, 0, 0, 0)
        a = 0; b = 0; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 2: (0, 0, 0, 1)
        a = 0; b = 0; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 3: (0, 0, 1, 0)
        a = 0; b = 0; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 4: (0, 0, 1, 1)
        a = 0; b = 0; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 5: (0, 1, 0, 0)
        a = 0; b = 1; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 6: (0, 1, 0, 1)
        a = 0; b = 1; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 7: (0, 1, 1, 0)
        a = 0; b = 1; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 8: (0, 1, 1, 1)
        a = 0; b = 1; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 9: (1, 0, 0, 0)
        a = 1; b = 0; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 9, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 10: (1, 0, 0, 1)
        a = 1; b = 0; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 10, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 11: (1, 0, 1, 0)
        a = 1; b = 0; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 11, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 12: (1, 0, 1, 1)
        a = 1; b = 0; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 12, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 13: (1, 1, 0, 0)
        a = 1; b = 1; c = 0; d = 0; #1;
        $fdisplay(file, "scenario: 13, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 14: (1, 1, 0, 1)
        a = 1; b = 1; c = 0; d = 1; #1;
        $fdisplay(file, "scenario: 14, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 15: (1, 1, 1, 0)
        a = 1; b = 1; c = 1; d = 0; #1;
        $fdisplay(file, "scenario: 15, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 16: (1, 1, 1, 1)
        a = 1; b = 1; c = 1; d = 1; #1;
        $fdisplay(file, "scenario: 16, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Close the file
        $fclose(file);
        
        // Finish simulation
        $finish;
    end
endmodule
