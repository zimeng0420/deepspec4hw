`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;

    // Outputs
    wire out;

    // Instantiate the DUT
    top_module uut (
        .a(a),
        .b(b),
        .out(out)
    );

    // File pointer
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1: a = 0, b = 0
        a = 0; b = 0; #1;
        $fdisplay(file, "scenario: 1, a = %d, b = %d, out = %d", a, b, out);
        
        // Scenario 2: a = 0, b = 1
        a = 0; b = 1; #1;
        $fdisplay(file, "scenario: 2, a = %d, b = %d, out = %d", a, b, out);
        
        // Scenario 3: a = 1, b = 0
        a = 1; b = 0; #1;
        $fdisplay(file, "scenario: 3, a = %d, b = %d, out = %d", a, b, out);
        
        // Scenario 4: a = 1, b = 1
        a = 1; b = 1; #1;
        $fdisplay(file, "scenario: 4, a = %d, b = %d, out = %d", a, b, out);
        
        // Scenario 5: Reset both inputs a and b
        a = 0; b = 0; #1;
        $fdisplay(file, "scenario: 5, a = %d, b = %d, out = %d", a, b, out);
        
        // Scenario 6: Toggle input a to 1 while holding input b at 0
        a = 1; b = 0; #1;
        $fdisplay(file, "scenario: 6, a = %d, b = %d, out = %d", a, b, out);
        
        // Scenario 7: Toggle input b to 1 while holding input a at 0
        a = 0; b = 1; #1;
        $fdisplay(file, "scenario: 7, a = %d, b = %d, out = %d", a, b, out);
        
        // Scenario 8: Set both inputs a and b to 0 again to observe the stability of the output
        a = 0; b = 0; #1;
        $fdisplay(file, "scenario: 8, a = %d, b = %d, out = %d", a, b, out);
        
        // Close the output file
        $fclose(file);
        
        // Finish simulation
        $finish;
    end

endmodule
