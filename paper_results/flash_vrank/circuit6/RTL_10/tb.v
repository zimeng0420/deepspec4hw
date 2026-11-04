`timescale 1ns / 1ps

module tb_top_module;
  reg [2:0] a;
  wire [15:0] q;

  // Instantiate the DUT (Device Under Test)
  top_module DUT (
    .a(a),
    .q(q)
  );

  // File handle for output
  integer outfile;

  initial begin
    // Open the output file
    outfile = $fopen("TBout.txt", "w");
    
    // Test scenario 1
    #15 a = 3'b000; // Input a = 0
    #5 $fdisplay(outfile, "scenario: 1, a = %d, q = %h", a, q);
    
    // Test scenario 2
    #5 a = 3'b001; // Input a = 1
    #5 $fdisplay(outfile, "scenario: 2, a = %d, q = %h", a, q);
    
    // Test scenario 3
    #5 a = 3'b010; // Input a = 2
    #5 $fdisplay(outfile, "scenario: 3, a = %d, q = %h", a, q);
    
    // Test scenario 4
    #5 a = 3'b011; // Input a = 3
    #5 $fdisplay(outfile, "scenario: 4, a = %d, q = %h", a, q);
    
    // Test scenario 5
    #5 a = 3'b100; // Input a = 4
    #5 $fdisplay(outfile, "scenario: 5, a = %d, q = %h", a, q);
    
    // Test scenario 6
    #5 a = 3'b101; // Input a = 5
    #5 $fdisplay(outfile, "scenario: 6, a = %d, q = %h", a, q);
    
    // Test scenario 7
    #5 a = 3'b110; // Input a = 6
    #5 $fdisplay(outfile, "scenario: 7, a = %d, q = %h", a, q);
    
    // Test scenario 8
    #5 a = 3'b111; // Input a = 7
    #5 $fdisplay(outfile, "scenario: 8, a = %d, q = %h", a, q);
    
    // Test scenario 9
    #5 a = 3'b000; // Reapply input a = 0
    #5 $fdisplay(outfile, "scenario: 9, a = %d, q = %h", a, q);
    
    // Test scenario 10
    #5 a = 3'b001; // Reapply input a = 1
    #5 $fdisplay(outfile, "scenario: 10, a = %d, q = %h", a, q);
    
    // Test scenario 11
    #5 a = 3'b010; // Reapply input a = 2
    #5 $fdisplay(outfile, "scenario: 11, a = %d, q = %h", a, q);
    
    // Test scenario 12
    #5 a = 3'b100; // Reapply input a = 4
    #5 $fdisplay(outfile, "scenario: 12, a = %d, q = %h", a, q);
    
    // Test scenario 13
    #5 a = 3'b001; // Reapply input a = 1
    #5 $fdisplay(outfile, "scenario: 13, a = %d, q = %h", a, q);
    
    // Test scenario 14
    #5 a = 3'b001; // Reapply input a = 1
    #5 $fdisplay(outfile, "scenario: 14, a = %d, q = %h", a, q);
    
    // Test scenario 15
    #5 a = 3'b011; // Reapply input a = 3
    #5 $fdisplay(outfile, "scenario: 15, a = %d, q = %h", a, q);
    
    // Test scenario 16
    #5 a = 3'b101; // Reapply input a = 5
    #5 $fdisplay(outfile, "scenario: 16, a = %d, q = %h", a, q);

    // Close the output file
    $fclose(outfile);
  end
endmodule
