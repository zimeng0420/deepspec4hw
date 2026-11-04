`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;
    reg c;
    reg d;
    reg e;

    // Outputs
    wire [24:0] out;

    // Instantiate the DUT
    top_module uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .out(out)
    );

    // File descriptor for output
    integer fd;

    initial begin
        // Open output file
        fd = $fopen("TBout.txt", "w");

        // Scenario 1
        a = 0; b = 0; c = 0; d = 0; e = 0; #1;
        $fdisplay(fd, "scenario: 1, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 2
        a = 0; b = 1; c = 0; d = 1; e = 1; #1;
        $fdisplay(fd, "scenario: 2, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 3
        a = 1; b = 1; c = 0; d = 0; e = 1; #1;
        $fdisplay(fd, "scenario: 3, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 4
        a = 1; b = 0; c = 1; d = 1; e = 0; #1;
        $fdisplay(fd, "scenario: 4, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 5
        a = 1; b = 1; c = 1; d = 0; e = 0; #1;
        $fdisplay(fd, "scenario: 5, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 6
        a = 0; b = 0; c = 1; d = 1; e = 1; #1;
        $fdisplay(fd, "scenario: 6, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 7
        a = 1; b = 0; c = 0; d = 0; e = 1; #1;
        $fdisplay(fd, "scenario: 7, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 8
        a = 1; b = 1; c = 1; d = 1; e = 1; #1;
        $fdisplay(fd, "scenario: 8, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 9
        a = 0; b = 1; c = 1; d = 0; e = 0; #1;
        $fdisplay(fd, "scenario: 9, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Scenario 10
        a = 0; b = 0; c = 1; d = 0; e = 1; #1;
        $fdisplay(fd, "scenario: 10, a = %d, b = %d, c = %d, d = %d, e = %d, out = %b", a, b, c, d, e, out);

        // Close the output file
        $fclose(fd);
    end

endmodule
