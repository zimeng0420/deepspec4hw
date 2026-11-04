`timescale 1ns / 1ps

module tb_top_module;

    // Parameters
    reg [255:0] in;
    reg [7:0] sel;
    wire out;

    // DUT Instantiation
    top_module dut (
        .in(in),
        .sel(sel),
        .out(out)
    );

    // File descriptor for output file
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        in = 256'b0; 
        sel = 8'b0;
        #1;
        $fdisplay(file, "scenario: 1, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 2
        in = 256'b1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111; 
        sel = 8'b1; 
        #1;
        $fdisplay(file, "scenario: 2, in = %b, sel = %d, out = %b", in, sel, out);
        
        // Scenario 3
        in = 256'b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111111111111111111; 
        sel = 8'd127; 
        #1;
        $fdisplay(file, "scenario: 3, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 4
        in = 256'b0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101; 
        sel = 8'd2; 
        #1;
        $fdisplay(file, "scenario: 4, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 5
        in = 256'b1100101010110110011010010000101011100101001011011100001101011111; 
        sel = 8'd255; 
        #1;
        $fdisplay(file, "scenario: 5, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 6
        in = 256'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000101010; 
        sel = 8'd42; 
        #1;
        $fdisplay(file, "scenario: 6, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 7
        in = 256'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111; 
        sel = 8'd8; 
        #1;
        $fdisplay(file, "scenario: 7, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 8
        in = 256'b1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010; 
        sel = 8'd100; 
        #1;
        $fdisplay(file, "scenario: 8, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 9
        in = 256'b00000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000; 
        sel = 8'd128; 
        #1;
        $fdisplay(file, "scenario: 9, in = %b, sel = %d, out = %b", in, sel, out);

        // Scenario 10
        in = 256'b1101010101011011010100100101010110100101010100110010110101010101; 
        sel = 8'd50; 
        #1;
        $fdisplay(file, "scenario: 10, in = %b, sel = %d, out = %b", in, sel, out);

        // Close the file
        $fclose(file);
        
        // End simulation
        $finish;
    end 

endmodule
