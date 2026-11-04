`timescale 1ns/1ps

module tb_top_module;

    // DUT inputs
    reg a;
    reg b;

    // DUT outputs
    wire out_assign;
    reg out_alwaysblock;

    // Instantiate the DUT
    top_module dut (
        .a(a),
        .b(b),
        .out_assign(out_assign),
        .out_alwaysblock(out_alwaysblock)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1: Set 'a' = 0 and 'b' = 0 at clock cycle 0
        a = 0; b = 0; #1; // Delay for stability
        $fdisplay(file, "scenario: 1, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Scenario 2: Set 'a' = 0 and 'b' = 1 at clock cycle 1
        a = 0; b = 1; #1; // Delay for stability
        $fdisplay(file, "scenario: 2, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Scenario 3: Set 'a' = 1 and 'b' = 0 at clock cycle 2
        a = 1; b = 0; #1; // Delay for stability
        $fdisplay(file, "scenario: 3, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Scenario 4: Set 'a' = 1 and 'b' = 1 at clock cycle 3
        a = 1; b = 1; #1; // Delay for stability
        $fdisplay(file, "scenario: 4, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Scenario 5: Change 'a' to 0 and 'b' to 0 at clock cycle 4
        a = 0; b = 0; #1; // Delay for stability
        $fdisplay(file, "scenario: 5, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Scenario 6: Change 'a' to 0 and 'b' to 1 at clock cycle 5
        a = 0; b = 1; #1; // Delay for stability
        $fdisplay(file, "scenario: 6, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Scenario 7: Change 'a' to 1 and 'b' to 0 at clock cycle 6
        a = 1; b = 0; #1; // Delay for stability
        $fdisplay(file, "scenario: 7, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Scenario 8: Change 'a' to 1 and 'b' to 1 at clock cycle 7
        a = 1; b = 1; #1; // Delay for stability
        $fdisplay(file, "scenario: 8, a = %d, b = %d, out_assign = %d, out_alwaysblock = %d", a, b, out_assign, out_alwaysblock);

        // Close the output file
        $fclose(file);
        $finish; // End simulation
    end

endmodule
