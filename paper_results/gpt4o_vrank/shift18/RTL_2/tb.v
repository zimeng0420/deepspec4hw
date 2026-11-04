`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  load;
reg  ena;
reg [1:0] amount;
reg [63:0] data;
wire [63:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.load(load),
	.ena(ena),
	.amount(amount),
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
    load = 1; ena = 0; data = 64'hA5A5A5A5A5A5A5A5;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 

    // Scenario 2
    scenario = 2;
    load = 0; ena = 1; amount = 2'b00;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 

    // Scenario 3
    scenario = 3;
    load = 0; ena = 1; amount = 2'b01;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 

    // Scenario 4
    scenario = 4;
    load = 0; ena = 1; amount = 2'b10;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 

    // Scenario 5
    scenario = 5;
    load = 0; ena = 1; amount = 2'b11;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 

    // Scenario 6
    scenario = 6;
    load = 1; ena = 0; data = 64'hFFFFFFFFFFFFFFFF;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 

    // Scenario 7
    scenario = 7;
    load = 0; ena = 1; amount = 2'b00;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    repeat(2) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 
    end

    // Scenario 8
    scenario = 8;
    load = 0; ena = 1; amount = 2'b11;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    repeat(2) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 
    end

    // Scenario 9
    scenario = 9;
    load = 1; $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; load = 0; ena = 1; amount = 2'b01;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    repeat(3) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); #10; 
    end

    // Scenario 10
    scenario = 10;
    load = 0; ena = 1; amount = 2'b10;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q); 
    #10; ena = 0;
    #10; // Ensure we check after ena goes low
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, amount = %d, data = %d, q = %d", scenario, clk, load, ena, amount, data, q);

    $fclose(file);
    $finish;
end

endmodule
