`timescale 1ns / 1ps

module tb_top_module;

// Inputs
reg [1:0] A;
reg [1:0] B;

// Outputs
wire z;

// Instantiate the Device Under Test (DUT)
top_module DUT (
    .A(A),
    .B(B),
    .z(z)
);

// File to export signals
integer file;

// Test scenario
initial begin
    // Open the output file
    file = $fopen("TBout.txt", "w");

    // Scenario 1
    A = 2'b00; B = 2'b00; #1; 
    $fdisplay(file, "scenario: 1, A = %d, B = %d, z = %d", A, B, z);
    
    // Scenario 2
    A = 2'b00; B = 2'b01; #1; 
    $fdisplay(file, "scenario: 2, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 3
    A = 2'b00; B = 2'b10; #1; 
    $fdisplay(file, "scenario: 3, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 4
    A = 2'b00; B = 2'b11; #1; 
    $fdisplay(file, "scenario: 4, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 5
    A = 2'b01; B = 2'b00; #1; 
    $fdisplay(file, "scenario: 5, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 6
    A = 2'b01; B = 2'b01; #1; 
    $fdisplay(file, "scenario: 6, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 7
    A = 2'b01; B = 2'b10; #1; 
    $fdisplay(file, "scenario: 7, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 8
    A = 2'b01; B = 2'b11; #1; 
    $fdisplay(file, "scenario: 8, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 9
    A = 2'b10; B = 2'b00; #1; 
    $fdisplay(file, "scenario: 9, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 10
    A = 2'b10; B = 2'b01; #1; 
    $fdisplay(file, "scenario: 10, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 11
    A = 2'b10; B = 2'b10; #1; 
    $fdisplay(file, "scenario: 11, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 12
    A = 2'b10; B = 2'b11; #1; 
    $fdisplay(file, "scenario: 12, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 13
    A = 2'b11; B = 2'b00; #1; 
    $fdisplay(file, "scenario: 13, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 14
    A = 2'b11; B = 2'b01; #1; 
    $fdisplay(file, "scenario: 14, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 15
    A = 2'b11; B = 2'b10; #1; 
    $fdisplay(file, "scenario: 15, A = %d, B = %d, z = %d", A, B, z);

    // Scenario 16
    A = 2'b11; B = 2'b11; #1; 
    $fdisplay(file, "scenario: 16, A = %d, B = %d, z = %d", A, B, z);

    // Close the output file
    $fclose(file);
    
    // End the simulation
    $finish;
end

endmodule
