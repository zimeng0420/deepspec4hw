`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;
    reg c;

    // Outputs
    wire out;

    // Instantiate the Device Under Test (DUT)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .out(out)
    );

    // File handle
    integer fh;

    initial begin
        // Open the output file
        fh = $fopen("TBout.txt", "w");
        
        // Scenario 1
        a = 0; b = 0; c = 0; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 1, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Scenario 2
        a = 0; b = 0; c = 1; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 2, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Scenario 3
        a = 0; b = 1; c = 0; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 3, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Scenario 4
        a = 0; b = 1; c = 1; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 4, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Scenario 5
        a = 1; b = 0; c = 0; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 5, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Scenario 6
        a = 1; b = 0; c = 1; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 6, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Scenario 7
        a = 1; b = 1; c = 0; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 7, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Scenario 8
        a = 1; b = 1; c = 1; 
        #1; // wait for 1 clock cycle
        $fdisplay(fh, "scenario: 8, a = %d, b = %d, c = %d, out = %d", a, b, c, out);
        
        // Close the output file
        $fclose(fh);
        
        // Finish simulation
        $finish;
    end

endmodule
