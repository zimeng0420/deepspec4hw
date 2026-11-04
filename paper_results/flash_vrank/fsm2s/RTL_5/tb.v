`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  j;
reg  k;
reg  reset;
wire  out;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.j(j),
	.k(k),
	.reset(reset),
	.out(out)
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
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out); #10; 
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 2
    scenario = 2;
    j = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10;
    k = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 3
    scenario = 3;
    j = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 4
    scenario = 4;
    k = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 5
    scenario = 5;
    k = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 6
    scenario = 6;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out); #10; 
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 7
    scenario = 7;
    j = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10;
    k = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out); #10; 
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 8
    scenario = 8;
    j = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    j = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    // scenario 9
    scenario = 9;
    k = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    k = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
    #10; 
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, reset = %d, out = %d", scenario, clk, j, k, reset, out);
        #10; 
    end

    $fclose(file);
    $finish;
end

endmodule
