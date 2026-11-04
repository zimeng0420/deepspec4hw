`timescale 1ns / 1ps

module testbench;
  
  // Input signals
  reg [7:0] a;
  reg [7:0] b;

  // Output signals
  wire [7:0] s;
  wire overflow;

  // Instantiate the DUT
  top_module DUT (
    .a(a),
    .b(b),
    .s(s),
    .overflow(overflow)
  );

  // File handle for output
  integer file;
  
  initial begin
    // Open the output file
    file = $fopen("TBout.txt", "w");
    
    // Scenario 1
    a = 8'd10; b = 8'd20; #1;
    $fdisplay(file, "scenario: 1, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 2
    a = 8'd251; b = 8'd3; #1; // -5 + 3
    $fdisplay(file, "scenario: 2, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 3
    a = 8'd100; b = 8'd50; #1;
    $fdisplay(file, "scenario: 3, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 4
    a = 8'd128; b = 8'd255; #1; // -128 + -1
    $fdisplay(file, "scenario: 4, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 5
    a = 8'd127; b = 8'd1; #1;
    $fdisplay(file, "scenario: 5, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 6
    a = 8'd64; b = 8'd192; #1; // 64 + -64
    $fdisplay(file, "scenario: 6, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 7
    a = 8'd192; b = 8'd187; #1; // -64 + -65
    $fdisplay(file, "scenario: 7, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 8
    a = 8'd63; b = 8'd192; #1; // 63 + -64
    $fdisplay(file, "scenario: 8, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 9
    a = 8'd12; b = 8'd34; #1;
    $fdisplay(file, "scenario: 9, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Scenario 10
    a = 8'd246; b = 8'd246; #1; // -10 + -10
    $fdisplay(file, "scenario: 10, a = %d, b = %d, s = %d, overflow = %d", a, b, s, overflow);
    
    // Close the output file
    $fclose(file);
    
    // Finish the simulation
    $finish;
  end

endmodule
