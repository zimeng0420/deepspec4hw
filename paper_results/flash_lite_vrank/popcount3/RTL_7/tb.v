`timescale 1ns / 1ps

module tb_top_module;

    // Declare the input and output signals of the DUT
    reg [2:0] in;
    wire [1:0] out;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .out(out)
    );

    // File descriptor for output file
    integer fd;

    initial begin
        // Open the output file
        fd = $fopen("TBout.txt", "w");
        
        // Test scenarios
        // Scenario 1: in = 3'b000
        in = 3'b000; 
        #1; 
        $fdisplay(fd, "scenario: 1, in = %d, out = %d", in, out);

        // Scenario 2: in = 3'b001
        in = 3'b001; 
        #1; 
        $fdisplay(fd, "scenario: 2, in = %d, out = %d", in, out);

        // Scenario 3: in = 3'b010
        in = 3'b010; 
        #1;
        $fdisplay(fd, "scenario: 3, in = %d, out = %d", in, out);

        // Scenario 4: in = 3'b011
        in = 3'b011; 
        #1; 
        $fdisplay(fd, "scenario: 4, in = %d, out = %d", in, out);

        // Scenario 5: in = 3'b100
        in = 3'b100; 
        #1; 
        $fdisplay(fd, "scenario: 5, in = %d, out = %d", in, out);

        // Scenario 6: in = 3'b101
        in = 3'b101; 
        #1; 
        $fdisplay(fd, "scenario: 6, in = %d, out = %d", in, out);

        // Scenario 7: in = 3'b110
        in = 3'b110; 
        #1; 
        $fdisplay(fd, "scenario: 7, in = %d, out = %d", in, out);

        // Scenario 8: in = 3'b111
        in = 3'b111; 
        #1; 
        $fdisplay(fd, "scenario: 8, in = %d, out = %d", in, out);

        // Close the output file
        $fclose(fd);
    end
endmodule
