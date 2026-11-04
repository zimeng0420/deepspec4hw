module testbench;
  // Parameter Declarations
  reg in1;
  reg in2;
  wire out;

  // DUT Instantiation
  top_module DUT (
    .in1(in1),
    .in2(in2),
    .out(out)
  );

  // File Handling
  integer file;

  initial begin
    // Open the file for writing
    file = $fopen("TBout.txt", "w");

    // Scenario 1: (0, 0)
    in1 = 0; in2 = 0;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 1, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Scenario 2: (0, 1)
    in1 = 0; in2 = 1;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 2, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Scenario 3: (1, 0)
    in1 = 1; in2 = 0;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 3, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Scenario 4: (1, 1)
    in1 = 1; in2 = 1;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 4, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Scenario 5: (0, 0) again
    in1 = 0; in2 = 0;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 5, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Scenario 6: (1, 0) again
    in1 = 1; in2 = 0;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 6, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Scenario 7: (0, 1) again
    in1 = 0; in2 = 1;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 7, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Scenario 8: (1, 1) again
    in1 = 1; in2 = 1;
    #10; // wait for signals to stabilize
    $fdisplay(file, "scenario: 8, in1 = %d, in2 = %d, out = %d", in1, in2, out);

    // Close the file
    $fclose(file);
    
    // End simulation
    $finish;
  end
endmodule
