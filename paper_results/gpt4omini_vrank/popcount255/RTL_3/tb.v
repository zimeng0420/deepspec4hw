`timescale 1ns/1ps

module tb_top_module;

  reg [254:0] in;
  wire [7:0] out;
  
  // Instantiate the DUT
  top_module DUT (
    .in(in),
    .out(out)
  );

  // File handle for output
  integer f;
  
  initial begin
    // Open the output file
    f = $fopen("TBout.txt", "w");
    
    // Scenario 1: All 0's
    in = 255'b0;
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 1, in = %b, out = %d", in, out);

    // Scenario 2: All 1's
    in = 255'b1;
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 2, in = %b, out = %d", in, out);

    // Scenario 3: Alternating pattern
    in = 255'b0101010101010101010101010101010101010101010101010101010101010101;
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 3, in = %b, out = %d", in, out);

    // Scenario 4: First random pattern
    in = 255'b110010101001010101011110011111001001100101111000100100011110001;
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 4, in = %b, out = %d", in, out);

    // Scenario 5: Second random pattern
    in = 255'b101001100001110010100101100110010000100101001010101100101110011;
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 5, in = %b, out = %d", in, out);

    // Scenario 6: First half 1's, second half 0's
    in = {128'b1, 127'b0}; // Corrected to 255 bits of 1's and 0's
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 6, in = %b, out = %d", in, out);

    // Scenario 7: More 1's than 0's
    in = {192'b1, 63'b0};
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 7, in = %b, out = %d", in, out);

    // Additional Scenario 6 verification: First half 1's, second half 0's (255 bits)
    in = {128'b1, 127'b0}; // This line is redundant, can be removed
    #1; // Wait for the output to stabilize
    $fdisplay(f, "scenario: 8, in = %b, out = %d", in, out);

    // Close the output file
    $fclose(f);
    
    // Finish the simulation
    $finish;
  end
endmodule
