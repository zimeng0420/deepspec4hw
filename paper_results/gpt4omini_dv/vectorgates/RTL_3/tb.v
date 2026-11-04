`timescale 1ns / 1ps

module tb_top_module;
    // Parameters
    reg [2:0] a; 
    reg [2:0] b; 
    wire [2:0] out_or_bitwise;
    wire out_or_logical;
    wire [5:0] out_not;

    // DUT instantiation
    top_module DUT (
        .a(a),
        .b(b),
        .out_or_bitwise(out_or_bitwise),
        .out_or_logical(out_or_logical),
        .out_not(out_not)
    );

    // File for exporting results
    integer file;

    // Initial block for test scenarios
    initial begin
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        a = 3'b000; b = 3'b000; #1;
        $fdisplay(file, "scenario: 1, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 2
        a = 3'b001; b = 3'b000; #1;
        $fdisplay(file, "scenario: 2, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 3
        a = 3'b000; b = 3'b001; #1;
        $fdisplay(file, "scenario: 3, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 4
        a = 3'b010; b = 3'b000; #1;
        $fdisplay(file, "scenario: 4, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 5
        a = 3'b000; b = 3'b010; #1;
        $fdisplay(file, "scenario: 5, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 6
        a = 3'b011; b = 3'b000; #1;
        $fdisplay(file, "scenario: 6, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 7
        a = 3'b000; b = 3'b011; #1;
        $fdisplay(file, "scenario: 7, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 8
        a = 3'b100; b = 3'b000; #1;
        $fdisplay(file, "scenario: 8, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 9
        a = 3'b000; b = 3'b100; #1;
        $fdisplay(file, "scenario: 9, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 10
        a = 3'b101; b = 3'b000; #1;
        $fdisplay(file, "scenario: 10, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 11
        a = 3'b000; b = 3'b101; #1;
        $fdisplay(file, "scenario: 11, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 12
        a = 3'b110; b = 3'b000; #1;
        $fdisplay(file, "scenario: 12, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 13
        a = 3'b000; b = 3'b110; #1;
        $fdisplay(file, "scenario: 13, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 14
        a = 3'b111; b = 3'b000; #1;
        $fdisplay(file, "scenario: 14, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 15
        a = 3'b000; b = 3'b111; #1;
        $fdisplay(file, "scenario: 15, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 16
        a = 3'b001; b = 3'b001; #1;
        $fdisplay(file, "scenario: 16, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 17
        a = 3'b010; b = 3'b001; #1;
        $fdisplay(file, "scenario: 17, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 18
        a = 3'b001; b = 3'b010; #1;
        $fdisplay(file, "scenario: 18, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 19
        a = 3'b011; b = 3'b010; #1;
        $fdisplay(file, "scenario: 19, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 20
        a = 3'b010; b = 3'b011; #1;
        $fdisplay(file, "scenario: 20, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 21
        a = 3'b001; b = 3'b100; #1;
        $fdisplay(file, "scenario: 21, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 22
        a = 3'b010; b = 3'b100; #1;
        $fdisplay(file, "scenario: 22, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 23
        a = 3'b100; b = 3'b001; #1;
        $fdisplay(file, "scenario: 23, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 24
        a = 3'b110; b = 3'b110; #1;
        $fdisplay(file, "scenario: 24, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);
        
        // Scenario 25
        a = 3'b111; b = 3'b111; #1;
        $fdisplay(file, "scenario: 25, a = %d, b = %d, out_or_bitwise = %d, out_or_logical = %d, out_not = %d", a, b, out_or_bitwise, out_or_logical, out_not);

        $fclose(file);
        $finish;
    end
    
endmodule
