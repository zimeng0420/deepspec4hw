`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg [15:0] in;

    // Outputs
    wire [7:0] out_hi;
    wire [7:0] out_lo;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

    // File handle for output
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        in = 16'h0000;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 1, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Scenario 2
        in = 16'hFFFF;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 2, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Scenario 3
        in = 16'h1234;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 3, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Scenario 4
        in = 16'hA5A5;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 4, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Scenario 5
        in = 16'h0F0F;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 5, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Scenario 6
        in = 16'hF0F0;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 6, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Scenario 7
        in = 16'hCAFE;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 7, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Scenario 8
        in = 16'hDEAD;
        #1;  // Wait for a stable output
        $fdisplay(file, "scenario: 8, in = %d, out_hi = %d, out_lo = %d", in, out_hi, out_lo);

        // Close the file
        $fclose(file);

        // Finish the simulation
        $finish;
    end

endmodule
