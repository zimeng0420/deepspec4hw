`timescale 1ns / 1ps

module tb_top_module;

    reg [4:1] x;
    wire f;

    // Instantiate the DUT
    top_module DUT (
        .x(x),
        .f(f)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        x = 4'b0000; // don't-care
        #10;
        $fdisplay(file, "scenario: 1, x = %b, f = %b", x, f);
        
        // Scenario 2
        x = 4'b0001; 
        #10;
        $fdisplay(file, "scenario: 2, x = %b, f = %b", x, f);
        
        // Scenario 3
        x = 4'b0010; // don't-care
        #10;
        $fdisplay(file, "scenario: 3, x = %b, f = %b", x, f);
        
        // Scenario 4
        x = 4'b0011; // f expected to be 1
        #10;
        $fdisplay(file, "scenario: 4, x = %b, f = %b", x, f);
        
        // Scenario 5
        x = 4'b0100; 
        #10;
        $fdisplay(file, "scenario: 5, x = %b, f = %b", x, f);
        
        // Scenario 6
        x = 4'b0101; // don't-care
        #10;
        $fdisplay(file, "scenario: 6, x = %b, f = %b", x, f);
        
        // Scenario 7
        x = 4'b0110; // f expected to be 1
        #10;
        $fdisplay(file, "scenario: 7, x = %b, f = %b", x, f);
        
        // Scenario 8
        x = 4'b0111; // f expected to be 1
        #10;
        $fdisplay(file, "scenario: 8, x = %b, f = %b", x, f);
        
        // Scenario 9
        x = 4'b1000; 
        #10;
        $fdisplay(file, "scenario: 9, x = %b, f = %b", x, f);
        
        // Scenario 10
        x = 4'b1001; // f expected to be 0
        #10;
        $fdisplay(file, "scenario: 10, x = %b, f = %b", x, f);
        
        // Scenario 11
        x = 4'b1010; 
        #10;
        $fdisplay(file, "scenario: 11, x = %b, f = %b", x, f);
        
        // Scenario 12
        x = 4'b1011; // don't-care
        #10;
        $fdisplay(file, "scenario: 12, x = %b, f = %b", x, f);
        
        // Scenario 13
        x = 4'b1100; // f expected to be 1
        #10;
        $fdisplay(file, "scenario: 13, x = %b, f = %b", x, f);
        
        // Scenario 14
        x = 4'b1101; // f expected to be 1
        #10;
        $fdisplay(file, "scenario: 14, x = %b, f = %b", x, f);
        
        // Scenario 15
        x = 4'b1110; // f expected to be 0
        #10;
        $fdisplay(file, "scenario: 15, x = %b, f = %b", x, f);
        
        // Scenario 16
        x = 4'b1111; // don't-care
        #10;
        $fdisplay(file, "scenario: 16, x = %b, f = %b", x, f);
        
        // Close the output file
        $fclose(file);
        
        // Finish the simulation
        $finish;
    end
endmodule
