`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg  ena;
wire  pm;
wire [7:0] hh;
wire [7:0] mm;
wire [7:0] ss;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.ena(ena),
	.pm(pm),
	.hh(hh),
	.mm(mm),
	.ss(ss)
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
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10;

    // Scenario 2
    scenario = 2;
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10;
    ena = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; // Wait for ss to increment
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; 

    // Scenario 3
    scenario = 3;
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    repeat(100) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; 
    end
    ena = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10;
    
    // Scenario 4
    scenario = 4;
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    repeat(120) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; 
    end
    ena = 0;

    // Scenario 5
    scenario = 5;
    ena = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10; // Brief toggle while ena is low
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; 
    
    // Scenario 6
    scenario = 6;
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; 
    repeat(30) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10;
    end
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; 
    
    // Scenario 7
    scenario = 7;
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    // Run clock to just before noon
    repeat(60) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    end
    ena = 0; // Transition to PM
    #10;
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
    repeat(60) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss); #10; 
    end

    // Scenario 8
    scenario = 8;
    repeat(10) begin
        ena = 1; 
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
        #10; 
        ena = 0; 
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, ena = %d, pm = %d, hh = %d, mm = %d, ss = %d", scenario, clk, reset, ena, pm, hh, mm, ss);
        #10; 
    end
    ena = 1;

    $fclose(file);
    $finish;
end

endmodule
