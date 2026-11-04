`timescale 1ns / 1ps

module tb_top_module;
    // Declare inputs and outputs
    reg [4:1] x;
    wire f;

    // Instantiate the DUT
    top_module DUT (
        .x(x),
        .f(f)
    );

    // File descriptor for output file
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");
        
        // Test scenarios
        x = 4'b0000; #1; $fdisplay(file, "scenario: 1, x = %b, f = %b", x, f);
        x = 4'b0001; #1; $fdisplay(file, "scenario: 2, x = %b, f = %b", x, f);
        x = 4'b0010; #1; $fdisplay(file, "scenario: 3, x = %b, f = %b", x, f);
        x = 4'b0011; #1; $fdisplay(file, "scenario: 4, x = %b, f = %b", x, f);
        x = 4'b0100; #1; $fdisplay(file, "scenario: 5, x = %b, f = %b", x, f);
        x = 4'b0101; #1; $fdisplay(file, "scenario: 6, x = %b, f = %b", x, f);
        x = 4'b0110; #1; $fdisplay(file, "scenario: 7, x = %b, f = %b", x, f);
        x = 4'b0111; #1; $fdisplay(file, "scenario: 8, x = %b, f = %b", x, f);
        x = 4'b1000; #1; $fdisplay(file, "scenario: 9, x = %b, f = %b", x, f);
        x = 4'b1001; #1; $fdisplay(file, "scenario: 10, x = %b, f = %b", x, f);
        x = 4'b1010; #1; $fdisplay(file, "scenario: 11, x = %b, f = %b", x, f);
        x = 4'b1011; #1; $fdisplay(file, "scenario: 12, x = %b, f = %b", x, f);
        x = 4'b1100; #1; $fdisplay(file, "scenario: 13, x = %b, f = %b", x, f);
        x = 4'b1101; #1; $fdisplay(file, "scenario: 14, x = %b, f = %b", x, f);
        x = 4'b1110; #1; $fdisplay(file, "scenario: 15, x = %b, f = %b", x, f);
        x = 4'b1111; #1; $fdisplay(file, "scenario: 16, x = %b, f = %b", x, f);

        // Close the file
        $fclose(file);
        $finish;
    end
endmodule
