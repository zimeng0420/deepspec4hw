`timescale 1ns / 1ps

module testbench;
    reg [15:0] scancode;
    wire left;
    wire down;
    wire right;
    wire up;

    // Instantiate the DUT
    top_module uut (
        .scancode(scancode),
        .left(left),
        .down(down),
        .right(right),
        .up(up)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        scancode = 16'hE06B; // Left arrow
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 1, scancode = %d, left = %d, down = %d, right = %d, up = %d", 
                  scancode, left, down, right, up);
        
        // Scenario 2
        scancode = 16'hE072; // Down arrow
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 2, scancode = %d, left = %d, down = %d, right = %d, up = %d", 
                  scancode, left, down, right, up);
        
        // Scenario 3
        scancode = 16'hE074; // Right arrow
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 3, scancode = %d, left = %d, down = %d, right = %d, up = %d", 
                  scancode, left, down, right, up);
        
        // Scenario 4
        scancode = 16'hE075; // Up arrow
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 4, scancode = %d, left = %d, down = %d, right = %d, up = %d", 
                  scancode, left, down, right, up);
        
        // Scenario 5
        scancode = 16'h0000; // None
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 5, scancode = %d, left = %d, down = %d, right = %d, up = %d", 
                  scancode, left, down, right, up);
        
        // Scenario 6
        scancode = 16'hE06B; // Left arrow again
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 6, scancode = %d, left = %d, down = %d, right = %d, up = %d", 
                  scancode, left, down, right, up);
        
        // Scenario 7
        scancode = 16'hE072; // Down arrow again
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 7, scancode = %d, left = %d, down = %d, right = %d, up = %d", 
                  scancode, left, down, right, up);
        
        // Close the output file
        $fclose(file);
        
        // Finish simulation
        $finish;
    end
endmodule
