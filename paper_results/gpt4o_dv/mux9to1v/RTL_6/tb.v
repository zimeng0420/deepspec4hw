`timescale 1ns/1ps

module testbench;
    // Parameters
    reg [15:0] a, b, c, d, e, f, g, h, i;
    reg [3:0] sel;
    wire [15:0] out;

    // DUT instance
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .i(i),
        .sel(sel),
        .out(out)
    );

    // File handling
    integer file;

    initial begin
        // Open file for writing
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        sel = 0;
        for (integer j = 0; j < 10; j = j + 1) begin
            a = $random;
            b = 16'h0000; c = 16'h0000; d = 16'h0000; e = 16'h0000;
            f = 16'h0000; g = 16'h0000; h = 16'h0000; i = 16'h0000;
            #10; // Delay for stability
            $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 2
        sel = 1;
        for (integer j = 0; j < 10; j = j + 1) begin
            b = $random;
            a = 16'h0000; c = 16'h0000; d = 16'h0000; e = 16'h0000;
            f = 16'h0000; g = 16'h0000; h = 16'h0000; i = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 3
        sel = 2;
        for (integer j = 0; j < 10; j = j + 1) begin
            c = $random;
            a = 16'h0000; b = 16'h0000; d = 16'h0000; e = 16'h0000;
            f = 16'h0000; g = 16'h0000; h = 16'h0000; i = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 4
        sel = 3;
        for (integer j = 0; j < 10; j = j + 1) begin
            d = $random;
            a = 16'h0000; b = 16'h0000; c = 16'h0000; e = 16'h0000;
            f = 16'h0000; g = 16'h0000; h = 16'h0000; i = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 5
        sel = 4;
        for (integer j = 0; j < 10; j = j + 1) begin
            e = $random;
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            f = 16'h0000; g = 16'h0000; h = 16'h0000; i = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 6
        sel = 5;
        for (integer j = 0; j < 10; j = j + 1) begin
            f = $random;
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; g = 16'h0000; h = 16'h0000; i = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 7
        sel = 6;
        for (integer j = 0; j < 10; j = j + 1) begin
            g = $random;
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; h = 16'h0000; i = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 8
        sel = 7;
        for (integer j = 0; j < 10; j = j + 1) begin
            h = $random;
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; g = 16'h0000; i = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 9
        sel = 8;
        for (integer j = 0; j < 10; j = j + 1) begin
            i = $random;
            a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
            e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
            #10;
            $fdisplay(file, "scenario: 9, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 10
        sel = 9;
        for (integer j = 0; j < 2; j = j + 1) begin
            a = $random; b = $random; c = $random; d = $random;
            e = $random; f = $random; g = $random; h = $random; 
            i = $random;
            #10;
            $fdisplay(file, "scenario: 10, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 11
        sel = 10;
        for (integer j = 0; j < 10; j = j + 1) begin
            a = $random; b = $random; c = $random; d = $random;
            e = $random; f = $random; g = $random; h = $random; 
            i = $random;
            #10;
            $fdisplay(file, "scenario: 11, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 12
        sel = 11;
        for (integer j = 0; j < 10; j = j + 1) begin
            a = $random; b = $random; c = $random; d = $random;
            e = $random; f = $random; g = $random; h = $random; 
            i = $random;
            #10;
            $fdisplay(file, "scenario: 12, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Scenario 13
        sel = 15;
        for (integer j = 0; j < 10; j = j + 1) begin
            a = $random; b = $random; c = $random; d = $random;
            e = $random; f = $random; g = $random; h = $random; 
            i = $random;
            #10;
            $fdisplay(file, "scenario: 13, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, g = %d, h = %d, i = %d, sel = %d, out = %d", a, b, c, d, e, f, g, h, i, sel, out);
        end

        // Close the file
        $fclose(file);
        $finish;
    end
endmodule
