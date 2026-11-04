`timescale 1ns / 1ps

module tb_top_module;

    // Declare inputs and outputs
    reg x;
    reg y;
    wire z;

    // Instantiate the DUT
    top_module dut (
        .x(x),
        .y(y),
        .z(z)
    );

    // File descriptor for output
    integer fd;

    initial begin
        // Open the output file
        fd = $fopen("TBout.txt", "w");

        // Scenario 1: x = 0, y = 0
        x = 0; 
        y = 0;
        #1; // Wait for 1 time unit
        $fdisplay(fd, "scenario: 1, x = %d, y = %d, z = %d", x, y, z);

        // Scenario 2: x = 0, y = 1
        x = 0; 
        y = 1;
        #1; // Wait for 1 time unit
        $fdisplay(fd, "scenario: 2, x = %d, y = %d, z = %d", x, y, z);

        // Scenario 3: x = 1, y = 0
        x = 1; 
        y = 0;
        #1; // Wait for 1 time unit
        $fdisplay(fd, "scenario: 3, x = %d, y = %d, z = %d", x, y, z);

        // Scenario 4: x = 1, y = 1
        x = 1; 
        y = 1;
        #1; // Wait for 1 time unit
        $fdisplay(fd, "scenario: 4, x = %d, y = %d, z = %d", x, y, z);

        // Close the output file
        $fclose(fd);
        $finish; // End the simulation
    end

endmodule
