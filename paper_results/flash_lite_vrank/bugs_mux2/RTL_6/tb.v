`timescale 1ns / 1ps

module tb_top_module;

    reg sel;
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] out;

    // Instantiate the DUT
    top_module dut (
        .sel(sel),
        .a(a),
        .b(b),
        .out(out)
    );

    integer file;

    initial begin
        // Open the file to write output
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        sel = 0; a = 8'b00000000; b = 8'b11111111; #1;
        $fdisplay(file, "scenario: 1, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 2
        sel = 0; a = 8'b10101010; b = 8'b01010101; #1;
        $fdisplay(file, "scenario: 2, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 3
        sel = 1; a = 8'b00000000; b = 8'b11111111; #1;
        $fdisplay(file, "scenario: 3, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 4
        sel = 1; a = 8'b10101010; b = 8'b01010101; #1;
        $fdisplay(file, "scenario: 4, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 5
        sel = 0; a = 8'b11111111; b = 8'b00000000; #1;
        $fdisplay(file, "scenario: 5, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 6
        sel = 1; a = 8'b11111111; b = 8'b00000000; #1;
        $fdisplay(file, "scenario: 6, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 7
        sel = 0; a = 8'b00001111; b = 8'b11110000; #1;
        $fdisplay(file, "scenario: 7, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 8
        sel = 1; a = 8'b00001111; b = 8'b11110000; #1;
        $fdisplay(file, "scenario: 8, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 9
        sel = 0; a = 8'b01010101; b = 8'b10101010; #1;
        $fdisplay(file, "scenario: 9, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Scenario 10
        sel = 1; a = 8'b01010101; b = 8'b10101010; #1;
        $fdisplay(file, "scenario: 10, sel = %d, a = %d, b = %d, out = %d", sel, a, b, out);

        // Close the file
        $fclose(file);
        $finish;
    end

endmodule
