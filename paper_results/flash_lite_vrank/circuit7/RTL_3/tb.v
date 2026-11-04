`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  a;
wire  q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.a(a),
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
    a = 1'bx; // changed from 'x' to 1'bx
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10;  // 0ns to 5ns
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 5ns to 15ns
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 2
    scenario = 2;
    a = 0;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 10ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 15ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 3
    scenario = 3;
    a = 0;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 20ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 25ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 4
    scenario = 4;
    a = 0;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 30ns delay
    a = 1;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 35ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 5
    scenario = 5;
    a = 1;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 40ns delay
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; // 45ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 6
    scenario = 6;
    a = 1;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 50ns delay
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; // 55ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 7
    scenario = 7;
    a = 1;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 60ns delay
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; // 65ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 8
    scenario = 8;
    a = 1;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 70ns delay
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; // 75ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 9
    scenario = 9;
    a = 1;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 80ns delay
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; // 85ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q); #10; 

    // scenario 10
    scenario = 10;
    a = 1;
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);
    #10; // 90ns delay
    $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, q = %d", scenario, clk, a, q);

    $fclose(file);
    $finish;
end

endmodule
