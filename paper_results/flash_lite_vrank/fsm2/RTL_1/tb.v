`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  j;
reg  k;
reg  areset;
wire  out;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.j(j),
	.k(k),
	.areset(areset),
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

    // Scenario 1
    scenario = 1;
    areset = 1;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end
    areset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    // Scenario 2
    scenario = 2;
    j = 1; k = 0;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end
    j = 0;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    // Scenario 3
    scenario = 3;
    k = 1;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end
    k = 0;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    // Scenario 4
    scenario = 4;
    k = 1;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end
    j = 0;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    // Scenario 5
    scenario = 5;
    j = 0; k = 1;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    // Scenario 6
    scenario = 6;
    areset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end
    areset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    // Scenario 7
    scenario = 7;
    j = 1;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end
    j = 0; k = 1;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    // Scenario 8
    scenario = 8;
    k = 0;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end
    k = 1;
    $fdisplay(file, "scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, j = %d, k = %d, areset = %d, out = %d", scenario, clk, j, k, areset, out);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
