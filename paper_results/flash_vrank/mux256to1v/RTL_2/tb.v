`timescale 1ns / 1ps

module tb_top_module;

    reg [1023:0] in;
    reg [7:0] sel;
    wire [3:0] out;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .sel(sel),
        .out(out)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Populate input vector with known values
        in = 1024'h0000000000000000000000000000000000000000000000000000000000000000_00000000000000000000000000000000_00000000000000000000000000000000_00000000000000000000000000000000_00000000000000000000000000000000_00000000000000000000000000000000_0000000000000000FF;

        // Scenario 1
        sel = 8'd0;  // sel = 0
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 1, in = %d, sel = %d, out = %d", in[3:0], sel, out);
        
        // Scenario 2
        sel = 8'd1;  // sel = 1
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 2, in = %d, sel = %d, out = %d", in[7:4], sel, out);
        
        // Scenario 3
        sel = 8'd2;  // sel = 2
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 3, in = %d, sel = %d, out = %d", in[11:8], sel, out);
        
        // Scenario 4
        sel = 8'd3;  // sel = 3
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 4, in = %d, sel = %d, out = %d", in[15:12], sel, out);
        
        // Scenario 5
        sel = 8'd4;  // sel = 4
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 5, in = %d, sel = %d, out = %d", in[19:16], sel, out);
        
        // Scenario 6
        sel = 8'd255;  // sel = 255
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 6, in = %d, sel = %d, out = %d", in[1023:1020], sel, out);
        
        // Scenario 7
        sel = 8'd125;  // sel = 125 (random selection)
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 7, in = %d, sel = %d, out = %d", in[499:496], sel, out);
        
        // Scenario 8
        sel = 8'd0;  // sel = 0 with all zeros
        in = 1024'd0; // all bits set to zero
        #10;  // Wait for signal stabilization
        $fdisplay(file, "scenario: 8, in = %d, sel = %d, out = %d", in[3:0], sel, out);
        
        // Close the output file
        $fclose(file);
        $finish;  // End the simulation
    end

endmodule
