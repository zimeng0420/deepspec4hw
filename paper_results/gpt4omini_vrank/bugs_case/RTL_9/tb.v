`timescale 1ns/1ps

module tb_top_module;

  reg [7:0] code;
  wire [3:0] out;
  wire valid;

  // Instantiate the DUT
  top_module DUT (
    .code(code),
    .out(out),
    .valid(valid)
  );

  integer file;

  initial begin
    // Open the output file
    file = $fopen("TBout.txt", "w");
    
    // Scenario 1
    code = 8'h45; #10;
    $fdisplay(file, "scenario: 1, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 2
    code = 8'h16; #10;
    $fdisplay(file, "scenario: 2, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 3
    code = 8'h1e; #10;
    $fdisplay(file, "scenario: 3, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 4
    code = 8'h26; #10;
    $fdisplay(file, "scenario: 4, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 5
    code = 8'h25; #10;
    $fdisplay(file, "scenario: 5, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 6
    code = 8'h2e; #10;
    $fdisplay(file, "scenario: 6, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 7
    code = 8'h36; #10;
    $fdisplay(file, "scenario: 7, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 8
    code = 8'h3d; #10;
    $fdisplay(file, "scenario: 8, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 9
    code = 8'h3e; #10;
    $fdisplay(file, "scenario: 9, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 10
    code = 8'h46; #10;
    $fdisplay(file, "scenario: 10, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 11
    code = 8'h00; #10;
    $fdisplay(file, "scenario: 11, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 12
    code = 8'h99; #10;
    $fdisplay(file, "scenario: 12, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 13
    code = 8'hAF; #10;
    $fdisplay(file, "scenario: 13, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 14
    code = 8'hBA; #10;
    $fdisplay(file, "scenario: 14, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Scenario 15
    code = 8'hFF; #10;
    $fdisplay(file, "scenario: 15, code = %d, out = %d, valid = %d", code, out, valid);
    
    // Close the output file
    $fclose(file);
    
    // End the simulation
    $finish;
  end

endmodule
