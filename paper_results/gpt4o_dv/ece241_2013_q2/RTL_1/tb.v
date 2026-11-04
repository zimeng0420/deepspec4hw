module testbench;
    // Input signals
    reg a;
    reg b;
    reg c;
    reg d;

    // Output signals
    wire out_sop;
    wire out_pos;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .out_sop(out_sop),
        .out_pos(out_pos)
    );

    // File descriptor
    integer fd;

    initial begin
        // Open file for writing
        fd = $fopen("TBout.txt", "w");

        // Scenario 1: 0000
        a = 0; b = 0; c = 0; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 1, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 2: 0001
        a = 0; b = 0; c = 0; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 2, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 3: 0010
        a = 0; b = 0; c = 1; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 3, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 4: 0011
        a = 0; b = 0; c = 1; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 4, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 5: 0100
        a = 0; b = 1; c = 0; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 5, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 6: 0101
        a = 0; b = 1; c = 0; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 6, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 7: 0110
        a = 0; b = 1; c = 1; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 7, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 8: 0111
        a = 0; b = 1; c = 1; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 8, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 9: 1000
        a = 1; b = 0; c = 0; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 9, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 10: 1001
        a = 1; b = 0; c = 0; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 10, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 11: 1010
        a = 1; b = 0; c = 1; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 11, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 12: 1011
        a = 1; b = 0; c = 1; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 12, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 13: 1100
        a = 1; b = 1; c = 0; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 13, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 14: 1101
        a = 1; b = 1; c = 0; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 14, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 15: 1110
        a = 1; b = 1; c = 1; d = 0;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 15, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Scenario 16: 1111
        a = 1; b = 1; c = 1; d = 1;
        #1; // Delay for signal stability
        $fdisplay(fd, "scenario: 16, a = %d, b = %d, c = %d, d = %d, out_sop = %d, out_pos = %d", a, b, c, d, out_sop, out_pos);

        // Close file
        $fclose(fd);
    end
endmodule
