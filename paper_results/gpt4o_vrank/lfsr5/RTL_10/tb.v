`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
wire [4:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
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
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);  
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);  
    #10;

    // Scenario 2
    scenario = 2;
    repeat(5) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    // Scenario 3
    scenario = 3;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);  
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);  
    #10;

    // Scenario 4
    scenario = 4;
    repeat(10) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    // Scenario 5
    scenario = 5;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);  
    #10;
    reset = 0; // Deassert reset in the same cycle
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);  
    #10;

    // Scenario 6
    scenario = 6;
    reset = 0; // Keep reset low
    repeat(31) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
