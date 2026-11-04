`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  j;
reg  k;
wire  Q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.j(j),
	.k(k),
	.Q(Q)
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
    j = 0; k = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end
    j = 0; k = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end

    // scenario 2
    scenario = 2;
    j = 1; k = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end
    j = 1; k = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end

    // scenario 3
    scenario = 3;
    j = 0; k = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end
    j = 1; k = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end
    j = 1; k = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end

    // scenario 4
    scenario = 4;
    j = 1; k = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end
    j = 0; k = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end

    // scenario 5
    scenario = 5;
    j = 0; k = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end
    j = 0; k = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end
    j = 1; k = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, Q = %d", scenario, clk, j, k, Q);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
