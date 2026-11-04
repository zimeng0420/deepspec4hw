`timescale 1ns / 1ps

module tb_top_module;

    reg [3:0] in;
    wire [2:0] out_both;
    wire [3:1] out_any;
    wire [3:0] out_different;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .out_both(out_both),
        .out_any(out_any),
        .out_different(out_different)
    );

    // File handling
    integer file;
    integer i;

    initial begin
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1 to 16
        in = 4'b0000; #0; // clock cycle 0
        $fdisplay(file, "scenario: 1, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b0001; #1; // clock cycle 1
        $fdisplay(file, "scenario: 2, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b0010; #1; // clock cycle 2
        $fdisplay(file, "scenario: 3, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b0011; #1; // clock cycle 3
        $fdisplay(file, "scenario: 4, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b0100; #1; // clock cycle 4
        $fdisplay(file, "scenario: 5, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b0101; #1; // clock cycle 5
        $fdisplay(file, "scenario: 6, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b0110; #1; // clock cycle 6
        $fdisplay(file, "scenario: 7, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b0111; #1; // clock cycle 7
        $fdisplay(file, "scenario: 8, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1000; #1; // clock cycle 8
        $fdisplay(file, "scenario: 9, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1001; #1; // clock cycle 9
        $fdisplay(file, "scenario: 10, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1010; #1; // clock cycle 10
        $fdisplay(file, "scenario: 11, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1011; #1; // clock cycle 11
        $fdisplay(file, "scenario: 12, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1100; #1; // clock cycle 12
        $fdisplay(file, "scenario: 13, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1101; #1; // clock cycle 13
        $fdisplay(file, "scenario: 14, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1110; #1; // clock cycle 14
        $fdisplay(file, "scenario: 15, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        in = 4'b1111; #1; // clock cycle 15
        $fdisplay(file, "scenario: 16, in = %d, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        $fclose(file);
        $finish;
    end

endmodule
