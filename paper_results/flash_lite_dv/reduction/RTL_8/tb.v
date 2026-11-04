`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg [7:0] in;

    // Outputs
    wire parity;

    // Instantiate the Device Under Test (DUT)
    top_module DUT (
        .in(in),
        .parity(parity)
    );

    // File for exporting signals
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        in = 8'b00000000;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 1, in = %d, parity = %d", in, parity);

        // Scenario 2
        in = 8'b00000001;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 2, in = %d, parity = %d", in, parity);

        // Scenario 3
        in = 8'b00000011;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 3, in = %d, parity = %d", in, parity);

        // Scenario 4
        in = 8'b00001111;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 4, in = %d, parity = %d", in, parity);

        // Scenario 5
        in = 8'b11111111;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 5, in = %d, parity = %d", in, parity);

        // Scenario 6
        in = 8'b10101010;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 6, in = %d, parity = %d", in, parity);

        // Scenario 7
        in = 8'b01010101;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 7, in = %d, parity = %d", in, parity);

        // Scenario 8
        in = 8'b00001100;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 8, in = %d, parity = %d", in, parity);

        // Scenario 9
        in = 8'b11110000;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 9, in = %d, parity = %d", in, parity);

        // Scenario 10
        in = 8'b11100011;
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 10, in = %d, parity = %d", in, parity);

        // Close the output file
        $fclose(file);
        
        // End simulation
        $finish;
    end

endmodule
