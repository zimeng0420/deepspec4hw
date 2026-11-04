`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg in1;
    reg in2;

    // Output
    wire out;

    // Instantiate the DUT
    top_module DUT (
        .in1(in1),
        .in2(in2),
        .out(out)
    );

    // File descriptor
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1: in1 = 0, in2 = 0
        in1 = 0; in2 = 0;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 1, in1 = %d, in2 = %d, out = %d", in1, in2, out);

        // Scenario 2: in1 = 0, in2 = 1
        in1 = 0; in2 = 1;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 2, in1 = %d, in2 = %d, out = %d", in1, in2, out);

        // Scenario 3: in1 = 1, in2 = 0
        in1 = 1; in2 = 0;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 3, in1 = %d, in2 = %d, out = %d", in1, in2, out);

        // Scenario 4: in1 = 1, in2 = 1
        in1 = 1; in2 = 1;
        #10; // Wait for signals to stabilize
        $fdisplay(file, "scenario: 4, in1 = %d, in2 = %d, out = %d", in1, in2, out);

        // Close the file
        $fclose(file);

        // End the simulation
        $finish;
    end

endmodule
