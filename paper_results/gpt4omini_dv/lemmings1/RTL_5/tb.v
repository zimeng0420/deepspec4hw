`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  bump_left;
reg  bump_right;
wire  walk_left;
wire  walk_right;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.areset(areset),
	.bump_left(bump_left),
	.bump_right(bump_right),
	.walk_left(walk_left),
	.walk_right(walk_right)
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
    areset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10;
    end
    areset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    #10;

    // scenario 2
    scenario = 2;
    bump_left = 0;
    bump_right = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(5) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    end

    // scenario 3
    scenario = 3;
    bump_right = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(2) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    end
    bump_right = 0; 

    // scenario 4
    scenario = 4;
    bump_left = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(2) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    end
    bump_left = 0; 

    // scenario 5
    scenario = 5;
    bump_left = 1; 
    bump_right = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(2) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    end
    bump_left = 0; 
    bump_right = 0; 

    // scenario 6
    scenario = 6; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(5) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    end

    // scenario 7
    scenario = 7;
    areset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10;
    end
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    #10;

    // scenario 8
    scenario = 8;
    bump_left = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(2) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    end
    bump_left = 0; 

    // scenario 9
    scenario = 9;
    bump_right = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(1) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right); #10; 
    end
    bump_right = 0; 

    // scenario 10
    scenario = 10;
    bump_left = 1; 
    bump_right = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    repeat(3) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, walk_left = %d, walk_right = %d", scenario, clk, areset, bump_left, bump_right, walk_left, walk_right);
    end
    bump_left = 0; 
    bump_right = 0; 

    // End simulation
    $fclose(file);
    $finish;
end

endmodule
