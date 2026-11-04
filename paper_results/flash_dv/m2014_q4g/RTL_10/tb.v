`timescale 1ns / 1ps

module testbench;

  // Declare inputs as reg and outputs as wire
  reg in1;
  reg in2;
  reg in3;
  wire out;

  // Instantiate the DUT
  top_module uut (
    .in1(in1),
    .in2(in2),
    .in3(in3),
    .out(out)
  );

  // File handling for output data
  integer file;
  
  initial begin
    // Open the file for writing
    file = $fopen("TBout.txt", "w");
    
    // Scenario 1: Set in1 = 0, in2 = 0, in3 = 0
    in1 = 0; in2 = 0; in3 = 0;
    #1; // Wait for 1 time unit for signals to stabilize
    $fdisplay(file, "scenario: 1, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Scenario 2: Set in1 = 0, in2 = 0, in3 = 1
    in1 = 0; in2 = 0; in3 = 1;
    #1; 
    $fdisplay(file, "scenario: 2, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Scenario 3: Set in1 = 0, in2 = 1, in3 = 0
    in1 = 0; in2 = 1; in3 = 0;
    #1; 
    $fdisplay(file, "scenario: 3, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Scenario 4: Set in1 = 0, in2 = 1, in3 = 1
    in1 = 0; in2 = 1; in3 = 1;
    #1; 
    $fdisplay(file, "scenario: 4, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Scenario 5: Set in1 = 1, in2 = 0, in3 = 0
    in1 = 1; in2 = 0; in3 = 0;
    #1; 
    $fdisplay(file, "scenario: 5, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Scenario 6: Set in1 = 1, in2 = 0, in3 = 1
    in1 = 1; in2 = 0; in3 = 1;
    #1; 
    $fdisplay(file, "scenario: 6, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Scenario 7: Set in1 = 1, in2 = 1, in3 = 0
    in1 = 1; in2 = 1; in3 = 0;
    #1; 
    $fdisplay(file, "scenario: 7, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Scenario 8: Set in1 = 1, in2 = 1, in3 = 1
    in1 = 1; in2 = 1; in3 = 1;
    #1; 
    $fdisplay(file, "scenario: 8, in1 = %d, in2 = %d, in3 = %d, out = %d", in1, in2, in3, out);
    
    // Close the file
    $fclose(file);
    
    // End the simulation
    $finish;
  end

endmodule
