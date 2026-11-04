`timescale 1ns / 1ps

module testbench;
    // Parameters
    reg in;          // Input signal
    wire out;       // Output signal

    // DUT Instantiation
    top_module DUT (
        .in(in),
        .out(out)
    );

    // File descriptor for output
    integer file;

    // Initial block for test cases
    initial begin
        // Open file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1: Apply input value 0
        in = 0; 
        #1;
        $fdisplay(file, "scenario: 1, in = %d, out = %d", in, out);
        
        // Scenario 2: Apply input value 1
        in = 1; 
        #1;
        $fdisplay(file, "scenario: 2, in = %d, out = %d", in, out);
        
        // Scenario 3: Apply input value 0 again
        in = 0; 
        #1;
        $fdisplay(file, "scenario: 3, in = %d, out = %d", in, out);
        
        // Scenario 4: Apply input value 1 again
        in = 1; 
        #1;
        $fdisplay(file, "scenario: 4, in = %d, out = %d", in, out);
        
        // Close the file
        $fclose(file);

        // End simulation
        $finish;
    end
endmodule
