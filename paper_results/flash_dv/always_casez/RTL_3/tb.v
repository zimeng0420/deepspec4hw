`timescale 1ns/1ps

module tb_top_module;

    // Declare input and output signals
    reg [7:0] in;
    wire [2:0] pos;

    // Instantiate the DUT
    top_module dut (
        .in(in),
        .pos(pos)
    );

    // File descriptor for output
    integer file;

    // Signal initialization
    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        in = 8'b00000000; #10;
        $fdisplay(file, "scenario: 1, in = %d, pos = %d", in, pos);

        // Scenario 2
        in = 8'b00000001; #10;
        $fdisplay(file, "scenario: 2, in = %d, pos = %d", in, pos);

        // Scenario 3
        in = 8'b00000010; #10;
        $fdisplay(file, "scenario: 3, in = %d, pos = %d", in, pos);

        // Scenario 4
        in = 8'b00000100; #10;
        $fdisplay(file, "scenario: 4, in = %d, pos = %d", in, pos);

        // Scenario 5
        in = 8'b00001000; #10;
        $fdisplay(file, "scenario: 5, in = %d, pos = %d", in, pos);

        // Scenario 6
        in = 8'b00010000; #10;
        $fdisplay(file, "scenario: 6, in = %d, pos = %d", in, pos);

        // Scenario 7
        in = 8'b00100000; #10;
        $fdisplay(file, "scenario: 7, in = %d, pos = %d", in, pos);

        // Scenario 8
        in = 8'b01000000; #10;
        $fdisplay(file, "scenario: 8, in = %d, pos = %d", in, pos);

        // Scenario 9
        in = 8'b10000000; #10;
        $fdisplay(file, "scenario: 9, in = %d, pos = %d", in, pos);

        // Scenario 10
        in = 8'b11000000; #10;
        $fdisplay(file, "scenario: 10, in = %d, pos = %d", in, pos);

        // Scenario 11
        in = 8'b10101010; #10;
        $fdisplay(file, "scenario: 11, in = %d, pos = %d", in, pos);

        // Scenario 12
        in = 8'b11111111; #10;
        $fdisplay(file, "scenario: 12, in = %d, pos = %d", in, pos);

        // Scenario 13
        in = 8'b01111111; #10;
        $fdisplay(file, "scenario: 13, in = %d, pos = %d", in, pos);

        // Scenario 14
        in = 8'b00001111; #10;
        $fdisplay(file, "scenario: 14, in = %d, pos = %d", in, pos);

        // Scenario 15
        in = 8'b01010101; #10;
        $fdisplay(file, "scenario: 15, in = %d, pos = %d", in, pos);

        // Close the file
        $fclose(file);
        
        // Finish the simulation
        $finish;
    end

endmodule
