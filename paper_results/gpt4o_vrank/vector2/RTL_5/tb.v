`timescale 1ns / 1ps

module tb_top_module;

    // Parameters
    reg [31:0] in;
    wire [31:0] out;

    // DUT Instance
    top_module dut (
        .in(in),
        .out(out)
    );

    // File Descriptor
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        in = 32'h00000000; 
        #1; 
        $fdisplay(file, "scenario: 1, in = %h, out = %h", in, out);

        // Scenario 2
        in = 32'hFFFFFFFF; 
        #1; 
        $fdisplay(file, "scenario: 2, in = %h, out = %h", in, out);

        // Scenario 3
        in = 32'h12345678; 
        #1; 
        $fdisplay(file, "scenario: 3, in = %h, out = %h", in, out);

        // Scenario 4
        in = 32'hAABBCCDD; 
        #1; 
        $fdisplay(file, "scenario: 4, in = %h, out = %h", in, out);

        // Scenario 5
        in = 32'hDEADBEEF; 
        #1; 
        $fdisplay(file, "scenario: 5, in = %h, out = %h", in, out);

        // Scenario 6
        in = 32'h1A2B3C4D; 
        #1; 
        $fdisplay(file, "scenario: 6, in = %h, out = %h", in, out);

        // Scenario 7
        in = 32'h98765432; 
        #1; 
        $fdisplay(file, "scenario: 7, in = %h, out = %h", in, out);

        // Scenario 8
        in = 32'h11223344; 
        #1; 
        $fdisplay(file, "scenario: 8, in = %h, out = %h", in, out);

        // Scenario 9
        in = 32'hFFFFFFFF; 
        #1; 
        $fdisplay(file, "scenario: 9, in = %h, out = %h", in, out);

        // Scenario 10
        in = 32'h0000FFFF; 
        #1; 
        $fdisplay(file, "scenario: 10, in = %h, out = %h", in, out);

        // Close the output file
        $fclose(file);
        $stop;
    end
endmodule
