`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  d;
reg  r;
wire  q;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .clk(clk),
    .d(d),
    .r(r),
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
    d = 0; r = 0;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;
    
    // scenario 2
    scenario = 2;
    d = 1; r = 0;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;
    
    // scenario 3
    scenario = 3;
    r = 1; d = 0;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;
    
    // scenario 4
    scenario = 4;
    r = 1; d = 1;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;
    
    // scenario 5
    scenario = 5;
    r = 1; d = 0;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;

    // scenario 6
    scenario = 6;
    r = 0; 
    d = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;
    d = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;

    // scenario 7
    scenario = 7;
    r = 1; d = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;

    // scenario 8
    scenario = 8;
    r = 1; d = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, r = %d, q = %d", scenario, clk, d, r, q);
    #10;

    $fclose(file);
    $finish;
end

endmodule
