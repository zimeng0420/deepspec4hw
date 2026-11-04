`timescale 1ns / 1ps

module tb_top_module;

    reg do_sub;
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] out;
    wire result_is_zero;

    // Instantiate the DUT
    top_module DUT (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

    // File to save output
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        do_sub = 0; a = 5; b = 3; #1;
        $fdisplay(file, "scenario: 1, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Scenario 2
        do_sub = 0; a = 15; b = 20; #2;
        $fdisplay(file, "scenario: 2, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Scenario 3
        do_sub = 1; a = 10; b = 5; #4;
        $fdisplay(file, "scenario: 3, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Scenario 4
        do_sub = 1; a = 3; b = 5; #6;
        $fdisplay(file, "scenario: 4, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Scenario 5
        do_sub = 0; a = 0; b = 0; #8;
        $fdisplay(file, "scenario: 5, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Scenario 6
        do_sub = 1; a = 4; b = 4; #10;
        $fdisplay(file, "scenario: 6, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Scenario 7
        do_sub = 0; a = 255; b = 1; #12;
        $fdisplay(file, "scenario: 7, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Scenario 8
        do_sub = 1; a = 200; b = 200; #14;
        $fdisplay(file, "scenario: 8, do_sub = %d, a = %d, b = %d, out = %d, result_is_zero = %d", do_sub, a, b, out, result_is_zero);

        // Close the file
        $fclose(file);
        
        // Finish the simulation
        $finish;
    end

endmodule
