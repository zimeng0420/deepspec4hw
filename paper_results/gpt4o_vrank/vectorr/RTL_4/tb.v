`timescale 1ns / 1ps

module tb_top_module;

    // Parameters
    reg [7:0] in;
    wire [7:0] out;

    // DUT instantiation
    top_module DUT (
        .in(in),
        .out(out)
    );

    // File descriptor for exporting signals
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        in = 8'b00000000; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 1, in = %d, out = %d", in, out);
        #1;

        // Scenario 2
        in = 8'b11111111; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 2, in = %d, out = %d", in, out);
        #1;

        // Scenario 3
        in = 8'b10101010; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 3, in = %d, out = %d", in, out);
        #1;

        // Scenario 4
        in = 8'b00011001; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 4, in = %d, out = %d", in, out);
        #1;

        // Scenario 5
        in = 8'b11100111; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 5, in = %d, out = %d", in, out);
        #1;

        // Scenario 6
        in = 8'b11001100; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 6, in = %d, out = %d", in, out);
        #1;

        // Scenario 7
        in = 8'b00111100; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 7, in = %d, out = %d", in, out);
        #1;

        // Scenario 8
        in = 8'b01010101; 
        #1; // Delay for signal stability
        $fdisplay(file, "scenario: 8, in = %d, out = %d", in, out);
        #1;

        // Close the file
        $fclose(file);
        $finish; // End the simulation
    end

endmodule
