`timescale 1ns / 1ps

module tb_top_module;

    reg x;
    reg y;
    wire z;

    // Instantiate the DUT
    top_module DUT (
        .x(x),
        .y(y),
        .z(z)
    );

    integer file;

    initial begin
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        x = 0; y = 0;
        #20;
        $fdisplay(file, "scenario: 1, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 2
        #5;
        x = 1; y = 0;
        #10;
        $fdisplay(file, "scenario: 2, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 3
        #5;
        x = 0; y = 1;
        #10;
        $fdisplay(file, "scenario: 3, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 4
        #5;
        x = 1; y = 1;
        #10;
        $fdisplay(file, "scenario: 4, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 5
        #5;
        x = 0; y = 0;
        #5;
        $fdisplay(file, "scenario: 5, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 6
        #5;
        x = 0; y = 1;
        #5;
        $fdisplay(file, "scenario: 6, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 7
        #5;
        x = 1; y = 1;
        #5;
        $fdisplay(file, "scenario: 7, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 8
        #5;
        x = 0; y = 1;
        #15;
        $fdisplay(file, "scenario: 8, x = %d, y = %d, z = %d", x, y, z);
        
        // Scenario 9
        #5;
        x = 1; y = 0;
        #5;
        $fdisplay(file, "scenario: 9, x = %d, y = %d, z = %d", x, y, z);

        $fclose(file);
    end

endmodule
