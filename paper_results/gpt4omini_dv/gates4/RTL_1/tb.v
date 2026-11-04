`timescale 1ns/1ps

module tb_top_module;

    // Declare inputs and outputs
    reg [3:0] in;
    wire out_and;
    wire out_or;
    wire out_xor;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );

    // Declare file handler
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        in = 4'b0000; #1;
        $fdisplay(file, "scenario: 1, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 2
        in = 4'b0001; #1;
        $fdisplay(file, "scenario: 2, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 3
        in = 4'b0010; #1;
        $fdisplay(file, "scenario: 3, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 4
        in = 4'b0011; #1;
        $fdisplay(file, "scenario: 4, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 5
        in = 4'b0100; #1;
        $fdisplay(file, "scenario: 5, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 6
        in = 4'b0101; #1;
        $fdisplay(file, "scenario: 6, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 7
        in = 4'b0110; #1;
        $fdisplay(file, "scenario: 7, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 8
        in = 4'b0111; #1;
        $fdisplay(file, "scenario: 8, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 9
        in = 4'b1000; #1;
        $fdisplay(file, "scenario: 9, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 10
        in = 4'b1001; #1;
        $fdisplay(file, "scenario: 10, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 11
        in = 4'b1010; #1;
        $fdisplay(file, "scenario: 11, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 12
        in = 4'b1011; #1;
        $fdisplay(file, "scenario: 12, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 13
        in = 4'b1100; #1;
        $fdisplay(file, "scenario: 13, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 14
        in = 4'b1101; #1;
        $fdisplay(file, "scenario: 14, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 15
        in = 4'b1110; #1;
        $fdisplay(file, "scenario: 15, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 16
        in = 4'b1111; #1;
        $fdisplay(file, "scenario: 16, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Close the file
        $fclose(file);
        $finish;
    end

endmodule
