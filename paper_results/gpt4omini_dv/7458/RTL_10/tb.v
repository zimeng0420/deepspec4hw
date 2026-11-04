`timescale 1ns / 1ps

module testbench;
    // Declare inputs as reg and outputs as wire
    reg p1a, p1b, p1c, p1d, p1e, p1f;
    reg p2a, p2b, p2c, p2d;
    wire p1y, p2y;

    // Instantiate the DUT
    top_module DUT (
        .p1a(p1a),
        .p1b(p1b),
        .p1c(p1c),
        .p1d(p1d),
        .p1e(p1e),
        .p1f(p1f),
        .p1y(p1y),
        .p2a(p2a),
        .p2b(p2b),
        .p2c(p2c),
        .p2d(p2d),
        .p2y(p2y)
    );

    // File descriptor for output
    integer fd;

    initial begin
        // Open the output file
        fd = $fopen("TBout.txt", "w");

        // Scenario 1
        p1a = 1; p1b = 1; p1c = 1; p1d = 0; p1e = 0; p1f = 0; p2a = 0; p2b = 0; p2c = 0; p2d = 0;
        #1; // Wait for signals to stabilize
        $fdisplay(fd, "scenario: 1, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);

        // Scenario 2
        p1a = 0; p1b = 0; p1c = 0; p1d = 1; p1e = 1; p1f = 1; p2a = 1; p2b = 1; p2c = 0; p2d = 0;
        #1;
        $fdisplay(fd, "scenario: 2, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);

        // Scenario 3
        p1a = 0; p1b = 0; p1c = 0; p1d = 0; p1e = 0; p1f = 0; p2a = 0; p2b = 0; p2c = 0; p2d = 0;
        #1;
        $fdisplay(fd, "scenario: 3, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);

        // Scenario 4
        p1a = 0; p1b = 0; p1c = 0; p1d = 1; p1e = 1; p1f = 0; p2a = 1; p2b = 0; p2c = 0; p2d = 0;
        #1;
        $fdisplay(fd, "scenario: 4, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);
                    
        // Scenario 5
        p1a = 1; p1b = 1; p1c = 0; p1d = 1; p1e = 0; p1f = 0; p2a = 0; p2b = 1; p2c = 0; p2d = 0;
        #1;
        $fdisplay(fd, "scenario: 5, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);
                    
        // Scenario 6
        p1a = 1; p1b = 1; p1c = 1; p1d = 1; p1e = 1; p1f = 1; p2a = 0; p2b = 0; p2c = 0; p2d = 0;
        #1;
        $fdisplay(fd, "scenario: 6, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);
                    
        // Scenario 7
        p1a = 0; p1b = 0; p1c = 0; p1d = 0; p1e = 1; p1f = 1; p2a = 1; p2b = 1; p2c = 0; p2d = 0;
        #1;
        $fdisplay(fd, "scenario: 7, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);
                    
        // Scenario 8
        p1a = 1; p1b = 1; p1c = 1; p1d = 0; p1e = 0; p1f = 0; p2a = 0; p2b = 0; p2c = 1; p2d = 1;
        #1;
        $fdisplay(fd, "scenario: 8, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);
                    
        // Scenario 9
        p1a = 1; p1b = 1; p1c = 1; p1d = 0; p1e = 0; p1f = 0; p2a = 0; p2b = 0; p2c = 0; p2d = 0;
        #1;
        $fdisplay(fd, "scenario: 9, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                    p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);
                    
        // Scenario 10
        // Iterate through various test combinations
        for (integer i = 0; i < 8; i = i + 1) begin
            {p1a, p1b, p1c, p1d, p1e, p1f, p2a, p2b, p2c, p2d} = i; // Fixed the assignment
            #1;
            $fdisplay(fd, "scenario: 10, p1a = %d, p1b = %d, p1c = %d, p1d = %d, p1e = %d, p1f = %d, p1y = %d, p2a = %d, p2b = %d, p2c = %d, p2d = %d, p2y = %d", 
                        p1a, p1b, p1c, p1d, p1e, p1f, p1y, p2a, p2b, p2c, p2d, p2y);
        end

        // Close the output file
        $fclose(fd);
        $finish;
    end
endmodule
