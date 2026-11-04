`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;
    reg c;
    reg d;

    // Outputs
    wire out;
    wire out_n;

    // Instantiate the Device Under Test (DUT)
    top_module DUT (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out(out),
        .out_n(out_n)
    );

    // File descriptor for output
    integer fout;

    initial begin
        // Open the output file
        fout = $fopen("TBout.txt", "w");
        
        // Scenario 1
        a = 0; b = 0; c = 0; d = 0; 
        #1; 
        $fdisplay(fout, "scenario: 1, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Scenario 2
        a = 0; b = 0; c = 1; d = 1; 
        #1; 
        $fdisplay(fout, "scenario: 2, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Scenario 3
        a = 0; b = 1; c = 0; d = 1; 
        #1; 
        $fdisplay(fout, "scenario: 3, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Scenario 4
        a = 1; b = 1; c = 0; d = 0; 
        #1; 
        $fdisplay(fout, "scenario: 4, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Scenario 5
        a = 1; b = 1; c = 1; d = 0; 
        #1; 
        $fdisplay(fout, "scenario: 5, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Scenario 6
        a = 1; b = 0; c = 1; d = 1; 
        #1; 
        $fdisplay(fout, "scenario: 6, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Scenario 7
        a = 1; b = 1; c = 1; d = 1; 
        #1; 
        $fdisplay(fout, "scenario: 7, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Scenario 8
        a = 0; b = 1; c = 1; d = 0; 
        #1; 
        $fdisplay(fout, "scenario: 8, a = %d, b = %d, c = %d, d = %d, out = %d, out_n = %d", a, b, c, d, out, out_n);

        // Close the output file
        $fclose(fout);
        $finish;
    end

endmodule
