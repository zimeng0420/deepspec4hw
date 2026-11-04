`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg a;
    reg b;
    reg c;
    reg d;

    // Outputs
    wire q;

    // Instantiate the DUT
    top_module uut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .q(q)
    );

    // File descriptor for output
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");
        if (file == 0) begin
            $display("Error opening file.");
            $finish;
        end

        // Scenario 1
        a = 0; b = 0; c = 0; d = 0; #5;
        #1 $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);
        
        // Scenario 2
        a = 0; b = 0; c = 0; d = 0; #5;
        #1 $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);
        
        // Scenario 3
        a = 0; b = 0; c = 0; d = 0; #5;
        #1 $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 4
        a = 0; b = 0; c = 0; d = 0; #5;
        #1 $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 5
        a = 0; b = 0; c = 0; d = 1; #5;
        #1 $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 6
        a = 0; b = 0; c = 1; d = 0; #5;
        #1 $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 7
        a = 0; b = 0; c = 1; d = 1; #5;
        #1 $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 8
        a = 0; b = 1; c = 0; d = 0; #5;
        #1 $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);
        
        // Scenario 9
        a = 0; b = 1; c = 0; d = 1; #5;
        #1 $fdisplay(file, "scenario: 9, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 10
        a = 0; b = 1; c = 1; d = 0; #5;
        #1 $fdisplay(file, "scenario: 10, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 11
        a = 0; b = 1; c = 1; d = 1; #5;
        #1 $fdisplay(file, "scenario: 11, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 12
        a = 1; b = 0; c = 0; d = 0; #5;
        #1 $fdisplay(file, "scenario: 12, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 13
        a = 1; b = 0; c = 0; d = 1; #5;
        #1 $fdisplay(file, "scenario: 13, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 14
        a = 1; b = 0; c = 1; d = 0; #5;
        #1 $fdisplay(file, "scenario: 14, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 15
        a = 1; b = 0; c = 1; d = 1; #5;
        #1 $fdisplay(file, "scenario: 15, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 16
        a = 1; b = 1; c = 0; d = 0; #5;
        #1 $fdisplay(file, "scenario: 16, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 17
        a = 1; b = 1; c = 0; d = 1; #5;
        #1 $fdisplay(file, "scenario: 17, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 18
        a = 1; b = 1; c = 1; d = 0; #5;
        #1 $fdisplay(file, "scenario: 18, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Scenario 19
        a = 1; b = 1; c = 1; d = 1; #5;
        #1 $fdisplay(file, "scenario: 19, a = %d, b = %d, c = %d, d = %d, q = %d", a, b, c, d, q);

        // Close the file
        $fclose(file);
        $finish;
    end

endmodule
