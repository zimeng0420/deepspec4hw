`timescale 1ns / 1ps

module testbench;
    reg [99:0] in;
    wire [99:0] out;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .out(out)
    );

    integer file;
    
    initial begin
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1a: All bits are 0
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
        #10; // Wait for one clock cycle
        $fdisplay(file, "scenario: 1a, in = %b, out = %b", in, out);
        
        // Scenario 2a: All bits are 1
        in = 100'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111;
        #10; // Wait for one clock cycle
        $fdisplay(file, "scenario: 2a, in = %b, out = %b", in, out);
        
        // Scenario 3a: Sequential input
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
        #10; // Wait for one clock cycle
        $fdisplay(file, "scenario: 3a, in = %b, out = %b", in, out);

        // Scenario 4a: Alternating bits
        in = 100'b0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101;
        #10; // Wait for one clock cycle
        $fdisplay(file, "scenario: 4a, in = %b, out = %b", in, out);

        // Scenario 5a: Binary representation of 255
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111;
        #10; // Wait for one clock cycle
        $fdisplay(file, "scenario: 5a, in = %b, out = %b", in, out);

        // Scenario 6a: Random bit pattern
        in = 100'b11001010101100010011001010111011000111010000100111011101011100011000010101001100111110101110101000;
        #10; // Wait for one clock cycle
        $fdisplay(file, "scenario: 6a, in = %b, out = %b", in, out);

        // Scenario 7a: First half ones, second half zeros
        in = 100'b1111111111111111111111111111111111111111111111111100000000000000000000000000000000000000000000000000;
        #10; // Wait for one clock cycle
        $fdisplay(file, "scenario: 7a, in = %b, out = %b", in, out);

        $fclose(file);
    end
endmodule
