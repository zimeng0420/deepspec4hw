`timescale 1ns / 1ps

module tb_top_module;

    // Parameters
    reg [3:1] y; // 3-bit input for state
    reg w;       // 1-bit input
    wire Y2;    // Output

    // Instantiate the DUT
    top_module DUT (
        .y(y),
        .w(w),
        .Y2(Y2)
    );

    // File handling for output
    integer file;

    initial begin
        // Open file for writing
        file = $fopen("TBout.txt", "w");

        // Test scenarios
        // Scenario 1
        y = 3'b000; w = 0; #1; // Initialize state A with w = 0
        $fdisplay(file, "scenario: 1, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 2
        y = 3'b000; w = 1; #1; // State A with w = 1
        $fdisplay(file, "scenario: 2, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 3
        y = 3'b001; w = 0; #1; // State B with w = 0
        $fdisplay(file, "scenario: 3, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 4
        y = 3'b001; w = 1; #1; // State B with w = 1
        $fdisplay(file, "scenario: 4, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 5
        y = 3'b010; w = 0; #1; // State C with w = 0
        $fdisplay(file, "scenario: 5, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 6
        y = 3'b010; w = 1; #1; // State C with w = 1
        $fdisplay(file, "scenario: 6, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 7
        y = 3'b011; w = 0; #1; // State D with w = 0
        $fdisplay(file, "scenario: 7, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 8
        y = 3'b011; w = 1; #1; // State D with w = 1
        $fdisplay(file, "scenario: 8, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 9
        y = 3'b100; w = 0; #1; // State E with w = 0
        $fdisplay(file, "scenario: 9, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 10
        y = 3'b100; w = 1; #1; // State E with w = 1
        $fdisplay(file, "scenario: 10, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 11
        y = 3'b101; w = 0; #1; // State F with w = 0
        $fdisplay(file, "scenario: 11, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 12
        y = 3'b101; w = 1; #1; // State F with w = 1
        $fdisplay(file, "scenario: 12, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 13
        y = 3'b000; w = 0; #1; // Transition from A to B
        $fdisplay(file, "scenario: 13, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 14
        y = 3'b001; w = 0; #1; // Transition from B to C
        $fdisplay(file, "scenario: 14, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Scenario 15
        y = 3'b011; w = 0; #1; // Transition from D to F
        $fdisplay(file, "scenario: 15, y = %d, w = %d, Y2 = %d", y, w, Y2);
        
        // Missing scenario to observe output after transitioning from A to B with w = 1
        y = 3'b000; w = 1; #1; // Transition from A to B with w = 1
        $fdisplay(file, "scenario: 16, y = %d, w = %d, Y2 = %d", y, w, Y2);

        // Closing the file
        $fclose(file);
        $finish;
    end

endmodule
