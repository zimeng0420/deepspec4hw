`timescale 1ns / 1ps

module tb_top_module();

// Inputs
reg [3:0] in;

// Outputs
wire [1:0] pos;

// Instantiate the Device Under Test (DUT)
top_module DUT (
    .in(in),
    .pos(pos)
);

// File handle for output
integer file;

// Initialize the testbench
initial begin
    // Open file to write outputs
    file = $fopen("TBout.txt", "w");
    
    // Scenario 1
    in = 4'b0000; #1; // Apply input at time 0, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 1, in = %d, pos = %d", in, pos);

    // Scenario 2
    in = 4'b0001; #1; // Apply input at time 1, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 2, in = %d, pos = %d", in, pos);

    // Scenario 3
    in = 4'b0010; #1; // Apply input at time 2, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 3, in = %d, pos = %d", in, pos);

    // Scenario 4
    in = 4'b0100; #1; // Apply input at time 3, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 4, in = %d, pos = %d", in, pos);

    // Scenario 5
    in = 4'b1000; #1; // Apply input at time 4, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 5, in = %d, pos = %d", in, pos);

    // Scenario 6
    in = 4'b1001; #1; // Apply input at time 5, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 6, in = %d, pos = %d", in, pos);

    // Scenario 7
    in = 4'b1100; #1; // Apply input at time 6, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 7, in = %d, pos = %d", in, pos);

    // Scenario 8
    in = 4'b1110; #1; // Apply input at time 7, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 8, in = %d, pos = %d", in, pos);
    
    // Scenario 9
    in = 4'b1111; #1; // Apply input at time 8, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 9, in = %d, pos = %d", in, pos);

    // Scenario 10
    in = 4'b0011; #1; // Apply input at time 9, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 10, in = %d, pos = %d", in, pos);

    // Scenario 11
    in = 4'b1010; #1; // Apply input at time 10, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 11, in = %d, pos = %d", in, pos);

    // Scenario 12
    in = 4'b1101; #1; // Apply input at time 11, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 12, in = %d, pos = %d", in, pos);

    // Scenario 13
    in = 4'b0111; #1; // Apply input at time 12, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 13, in = %d, pos = %d", in, pos);

    // Scenario 14
    in = 4'b0101; #1; // Apply input at time 13, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 14, in = %d, pos = %d", in, pos);

    // Scenario 15 (Random pattern)
    in = 4'b1110; #1; // Apply random pattern at time 14, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 15, in = %d, pos = %d", in, pos);

    // Scenario 16 (Random pattern)
    in = 4'b1000; #1; // Apply random pattern at time 15, check for 1 clock cycle
    #10;
    $fdisplay(file, "scenario: 16, in = %d, pos = %d", in, pos);

    // Close the file
    $fclose(file);
    
    // End simulation
    $finish;
end

endmodule
