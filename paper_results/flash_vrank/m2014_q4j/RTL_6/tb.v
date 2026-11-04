`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg [3:0] x;
    reg [3:0] y;

    // Outputs
    wire [4:0] sum;

    // Instantiate the DUT
    top_module uut (
        .x(x),
        .y(y),
        .sum(sum)
    );

    // File descriptor
    integer fd;

    initial begin
        // Open the file for writing
        fd = $fopen("TBout.txt", "w");

        // Test scenarios
        // Scenario 1
        x = 4'b0000; y = 4'b0000; #1; 
        $fdisplay(fd, "scenario: 1, x = %d, y = %d, sum = %d", x, y, sum);

        // Scenario 2
        x = 4'b0001; y = 4'b0001; #1; 
        $fdisplay(fd, "scenario: 2, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 3
        x = 4'b0010; y = 4'b0010; #1; 
        $fdisplay(fd, "scenario: 3, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 4
        x = 4'b0011; y = 4'b0001; #1; 
        $fdisplay(fd, "scenario: 4, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 5
        x = 4'b0111; y = 4'b0001; #1; 
        $fdisplay(fd, "scenario: 5, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 6
        x = 4'b1111; y = 4'b0001; #1; 
        $fdisplay(fd, "scenario: 6, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 7
        x = 4'b0101; y = 4'b1001; #1; 
        $fdisplay(fd, "scenario: 7, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 8
        x = 4'b1000; y = 4'b1000; #1; 
        $fdisplay(fd, "scenario: 8, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 9
        x = 4'b1100; y = 4'b0011; #1; 
        $fdisplay(fd, "scenario: 9, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 10
        x = 4'b1110; y = 4'b0010; #1; 
        $fdisplay(fd, "scenario: 10, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 11
        x = 4'b1001; y = 4'b1001; #1; 
        $fdisplay(fd, "scenario: 11, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 12
        x = 4'b1010; y = 4'b0101; #1; 
        $fdisplay(fd, "scenario: 12, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 13
        x = 4'b1101; y = 4'b0010; #1; 
        $fdisplay(fd, "scenario: 13, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 14
        x = 4'b1111; y = 4'b1111; #1; 
        $fdisplay(fd, "scenario: 14, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 15
        x = 4'b0110; y = 4'b0110; #1; 
        $fdisplay(fd, "scenario: 15, x = %d, y = %d, sum = %d", x, y, sum);
        
        // Scenario 16
        x = 4'b0011; y = 4'b1100; #1; 
        $fdisplay(fd, "scenario: 16, x = %d, y = %d, sum = %d", x, y, sum);

        // Close the file
        $fclose(fd);
    end

endmodule
