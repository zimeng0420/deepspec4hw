`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  resetn;
reg [3:1] r;
wire [3:1] g;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.resetn(resetn),
	.r(r),
	.g(g)
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
    resetn = 0;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10;
    resetn = 1;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    r = 3'b000;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 2
    scenario = 2;
    r = 3'b001;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 3
    scenario = 3;
    r = 3'b010;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 4
    scenario = 4;
    r = 3'b000;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 5
    scenario = 5;
    r = 3'b100;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 6
    scenario = 6;
    r = 3'b000;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    r = 3'b001;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 7
    scenario = 7;
    r = 3'b010;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 8
    scenario = 8;
    r = 3'b010;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 9
    scenario = 9;
    r = 3'b000;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    // Scenario 10
    scenario = 10;
    r = 3'b111;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, r = %d, g = %d", scenario, clk, resetn, r, g);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
