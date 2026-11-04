`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  load;
reg [1:0] ena;
reg [99:0] data;
wire [99:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .clk(clk),
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

    // scenario 1
    scenario = 1;
    load = 1;
    ena = 2'b00;
    data = 100'b1010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    load = 0;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 2
    scenario = 2;
    ena = 2'b01;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 3
    scenario = 3;
    ena = 2'b10;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 4
    scenario = 4;
    ena = 2'b00;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 5
    scenario = 5;
    load = 1;
    ena = 2'b00;
    data = 100'b1100110011001100110011001100110011001100110011001100110011001100110011001100110011001100110011001100;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    load = 0;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 6
    scenario = 6;
    ena = 2'b11;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 7
    scenario = 7;
    ena = 2'b01;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 8
    scenario = 8;
    ena = 2'b10;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 9
    scenario = 9;
    load = 1;
    data = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    load = 0;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q); #10; 

    // scenario 10
    scenario = 10;
    ena = 2'b01;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    ena = 2'b10;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    ena = 2'b00;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, ena = %d, data = %d, q = %d", scenario, clk, load, ena, data, q);

    $fclose(file);
    $finish;
end

endmodule
