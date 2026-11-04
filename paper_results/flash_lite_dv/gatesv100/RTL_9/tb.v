`timescale 1ns / 1ps

module tb_top_module;
    // Parameters
    reg [99:0] in;
    wire [98:0] out_both;
    wire [99:1] out_any;
    wire [99:0] out_different;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .out_both(out_both),
        .out_any(out_any),
        .out_different(out_different)
    );

    integer fd;

    initial begin
        // Open the file for writing
        fd = $fopen("TBout.txt", "w");

        // Scenario 1
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        #10;
        $fdisplay(fd, "scenario: 1, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Scenario 2
        in = 100'b1100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        #10;
        $fdisplay(fd, "scenario: 2, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Scenario 3
        in = 100'b1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010;
        #10;
        $fdisplay(fd, "scenario: 3, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Scenario 4
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111;
        #10;
        $fdisplay(fd, "scenario: 4, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Scenario 5
        in = 100'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
        #10;
        $fdisplay(fd, "scenario: 5, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Scenario 6
        in = 100'b0000000000000000000000000000000000000000000000000111111000000000000000000000000000000000000000000000;
        #10;
        $fdisplay(fd, "scenario: 6, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Scenario 7
        in = 100'b1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
        #10;
        $fdisplay(fd, "scenario: 7, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Scenario 8
        in = 100'b1100101010110001010100111101101010101110100101001011101011110001110000110000000000100101101010000010;
        #10;
        $fdisplay(fd, "scenario: 8, in = %b, out_both = %b, out_any = %b, out_different = %b", in, out_both, out_any, out_different);

        // Close the file
        $fclose(fd);
        $finish;
    end
endmodule
