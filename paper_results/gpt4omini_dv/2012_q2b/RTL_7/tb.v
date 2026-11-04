`timescale 1ns / 1ps

module tb_top_module;

    // Input signals
    reg [5:0] y;
    reg w;

    // Output signals
    wire Y1;
    wire Y3;

    // Instantiate the DUT
    top_module DUT (
        .y(y),
        .w(w),
        .Y1(Y1),
        .Y3(Y3)
    );

    // File descriptor for output
    integer fd;

    initial begin
        // Open the file to write output
        fd = $fopen("TBout.txt", "w");
        
        // Test scenarios
        // Scenario 1
        y = 6'b000001; w = 1; #1;
        $fdisplay(fd, "scenario: 1, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 2
        y = 6'b000001; w = 0; #1;
        $fdisplay(fd, "scenario: 2, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);
        
        // Scenario 3
        y = 6'b000010; w = 1; #1;
        $fdisplay(fd, "scenario: 3, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 4
        y = 6'b000010; w = 0; #1;
        $fdisplay(fd, "scenario: 4, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 5
        y = 6'b000100; w = 1; #1;
        $fdisplay(fd, "scenario: 5, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 6
        y = 6'b000100; w = 0; #1;
        $fdisplay(fd, "scenario: 6, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 7
        y = 6'b001000; w = 1; #1;
        $fdisplay(fd, "scenario: 7, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 8
        y = 6'b001000; w = 0; #1;
        $fdisplay(fd, "scenario: 8, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 9
        y = 6'b010000; w = 1; #1;
        $fdisplay(fd, "scenario: 9, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 10
        y = 6'b010000; w = 0; #1;
        $fdisplay(fd, "scenario: 10, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 11
        y = 6'b100000; w = 1; #1;
        $fdisplay(fd, "scenario: 11, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Scenario 12
        y = 6'b100000; w = 0; #1;
        $fdisplay(fd, "scenario: 12, y = %b, w = %b, Y1 = %b, Y3 = %b", y, w, Y1, Y3);

        // Close the file
        $fclose(fd);
        $finish;
    end

endmodule
