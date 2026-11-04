`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
wire [3:1] ena;
wire [15:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.ena(ena),
	.q(q)
);
// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    file = $fopen("TBout.txt", "w");
end
// Scenario Based Test
initial begin

    // Scenario 1
    scenario = 1;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q);
    #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 

    // Scenario 2
    scenario = 2;
    repeat(10) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    end

    // Scenario 3
    scenario = 3;
    repeat(5) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    end

    // Scenario 4
    scenario = 4;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q);
    #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 

    // Scenario 5
    scenario = 5;
    repeat(30) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    end

    // Scenario 6
    scenario = 6;
    repeat(100) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    end

    // Scenario 7
    scenario = 7;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q);
    #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q);
    #10;
    reset = 0;  
    repeat(5) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    end

    // Scenario 8
    scenario = 8;
    repeat(50) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q);
    end
    reset = 1;  
    #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, q = %d", scenario, clk, reset, ena, q);

    $fclose(file);
    $finish;
end

endmodule
