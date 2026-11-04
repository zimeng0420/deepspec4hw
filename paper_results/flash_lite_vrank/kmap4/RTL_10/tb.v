`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;
    reg c;
    reg d;

    // Output
    wire out;

    // Instantiate the DUT
    top_module uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out(out)
    );

    // File descriptor for output
    integer fd;

    initial begin
        // Open the output file
        fd = $fopen("TBout.txt", "w");

        // Scenario 1
        a = 0; b = 0; c = 0; d = 0; #0;
        $fdisplay(fd, "scenario: 1, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 2
        a = 0; b = 0; c = 0; d = 1; #1;
        $fdisplay(fd, "scenario: 2, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 3
        a = 0; b = 0; c = 1; d = 0; #1;
        $fdisplay(fd, "scenario: 3, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 4
        a = 0; b = 0; c = 1; d = 1; #1;
        $fdisplay(fd, "scenario: 4, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Scenario 5
        a = 0; b = 1; c = 0; d = 0; #1;
        $fdisplay(fd, "scenario: 5, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 6
        a = 0; b = 1; c = 0; d = 1; #1;
        $fdisplay(fd, "scenario: 6, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 7
        a = 0; b = 1; c = 1; d = 0; #1;
        $fdisplay(fd, "scenario: 7, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 8
        a = 0; b = 1; c = 1; d = 1; #1;
        $fdisplay(fd, "scenario: 8, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 9
        a = 1; b = 0; c = 0; d = 0; #1;
        $fdisplay(fd, "scenario: 9, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 10
        a = 1; b = 0; c = 0; d = 1; #1;
        $fdisplay(fd, "scenario: 10, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 11
        a = 1; b = 0; c = 1; d = 0; #1;
        $fdisplay(fd, "scenario: 11, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 12
        a = 1; b = 0; c = 1; d = 1; #1;
        $fdisplay(fd, "scenario: 12, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 13
        a = 1; b = 1; c = 0; d = 0; #1;
        $fdisplay(fd, "scenario: 13, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 14
        a = 1; b = 1; c = 0; d = 1; #1;
        $fdisplay(fd, "scenario: 14, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 15
        a = 1; b = 1; c = 1; d = 0; #1;
        $fdisplay(fd, "scenario: 15, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);

        // Scenario 16
        a = 1; b = 1; c = 1; d = 1; #1;
        $fdisplay(fd, "scenario: 16, a = %d, b = %d, c = %d, d = %d, out = %d", a, b, c, d, out);
        
        // Close the output file
        $fclose(fd);
        
        $finish;
    end

endmodule
