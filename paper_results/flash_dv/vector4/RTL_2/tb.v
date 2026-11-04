`timescale 1ns / 1ps

module tb_top_module;

    reg [7:0] in;
    wire [31:0] out;

    // Instantiate the Device Under Test (DUT)
    top_module DUT (
        .in(in),
        .out(out)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1: Apply input 'in = 8'b00000000'
        in = 8'b00000000; #1;
        $fdisplay(file, "scenario: 1, in = %d, out = %d", in, out);

        // Scenario 2: Apply input 'in = 8'b00000001'
        in = 8'b00000001; #1;
        $fdisplay(file, "scenario: 2, in = %d, out = %d", in, out);

        // Scenario 3: Apply input 'in = 8'b01111111'
        in = 8'b01111111; #1;
        $fdisplay(file, "scenario: 3, in = %d, out = %d", in, out);

        // Scenario 4: Apply input 'in = 8'b10000000'
        in = 8'b10000000; #1;
        $fdisplay(file, "scenario: 4, in = %d, out = %d", in, out);

        // Scenario 5: Apply input 'in = 8'b11111111'
        in = 8'b11111111; #1;
        $fdisplay(file, "scenario: 5, in = %d, out = %d", in, out);

        // Scenario 6: Apply input 'in = 8'b11111110'
        in = 8'b11111110; #1;
        $fdisplay(file, "scenario: 6, in = %d, out = %d", in, out);

        // Scenario 7: Apply input 'in = 8'b00001111'
        in = 8'b00001111; #1;
        $fdisplay(file, "scenario: 7, in = %d, out = %d", in, out);

        // Scenario 8: Apply input 'in = 8'b10001111'
        in = 8'b10001111; #1;
        $fdisplay(file, "scenario: 8, in = %d, out = %d", in, out);

        // Scenario 9: Apply input 'in = 8'b00001010'
        in = 8'b00001010; #1; // Added clock cycle delay to ensure stability of output
        $fdisplay(file, "scenario: 9, in = %d, out = %d", in, out);
        #1; // Additional delay to verify output stability
        $fdisplay(file, "scenario: 9 (stability check), in = %d, out = %d", in, out);

        // Scenario 10: Apply input 'in = 8'b11110000'
        in = 8'b11110000; #1;
        $fdisplay(file, "scenario: 10, in = %d, out = %d", in, out);

        // Close the output file
        $fclose(file);
        $finish; // End simulation
    end

endmodule
