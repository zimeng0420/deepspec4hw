`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  load;
reg  ena;
reg [3:0] data;
wire [3:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.areset(areset),
	.load(load),
	.ena(ena),
	.data(data),
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
    areset = 1; load = 0; ena = 0; data = 4'b0000;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end
    areset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    // Scenario 2
    scenario = 2;
    load = 1; areset = 0; ena = 0; data = 4'b1010;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end
    load = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    // Scenario 3
    scenario = 3;
    load = 1; data = 4'b1101; areset = 0; ena = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end
    ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    // Scenario 4
    scenario = 4;
    load = 0; ena = 1;
    repeat(3) begin
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    // Scenario 5
    scenario = 5;
    areset = 1; load = 0; ena = 0; data = 4'b0000;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end
    areset = 0; load = 1; data = 4'b1111;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    // Scenario 6
    scenario = 6;
    load = 1; ena = 1; areset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    // Scenario 7
    scenario = 7;
    load = 0; ena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    // Scenario 8
    scenario = 8;
    areset = 1; load = 1; ena = 1; data = 4'b0000;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, areset, load, ena, data, q);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
