`timescale 1ns / 1ps

module tb_top_module;

  // Inputs
  reg a;
  reg b;
  reg c;

  // Outputs
  wire w;
  wire x;
  wire y;
  wire z;

  // Instantiate the DUT
  top_module uut (
    .a(a),
    .b(b),
    .c(c),
    .w(w),
    .x(x),
    .y(y),
    .z(z)
  );

  // File handling for output
  integer file;

  initial begin
    // Open the output file
    file = $fopen("TBout.txt", "w");

    // Scenario 1: a = 0, b = 0, c = 0
    a = 0; b = 0; c = 0;
    #1;
    $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Scenario 2: a = 1, b = 0, c = 0
    a = 1; b = 0; c = 0;
    #1;
    $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Scenario 3: a = 0, b = 1, c = 0
    a = 0; b = 1; c = 0;
    #1;
    $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Scenario 4: a = 0, b = 0, c = 1
    a = 0; b = 0; c = 1;
    #1;
    $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Scenario 5: a = 1, b = 1, c = 0
    a = 1; b = 1; c = 0;
    #1;
    $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Scenario 6: a = 0, b = 1, c = 1
    a = 0; b = 1; c = 1;
    #1;
    $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Scenario 7: a = 1, b = 0, c = 1
    a = 1; b = 0; c = 1;
    #1;
    $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Scenario 8: a = 1, b = 1, c = 1
    a = 1; b = 1; c = 1;
    #1;
    $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, w, x, y, z);

    // Close the output file
    $fclose(file);
    
    // End the simulation
    $finish;
  end

endmodule
