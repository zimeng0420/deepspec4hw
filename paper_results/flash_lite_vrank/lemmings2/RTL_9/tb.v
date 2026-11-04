`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  bump_left;
reg  bump_right;
reg  ground;
wire  walk_left;
wire  walk_right;
wire  aaah;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.areset(areset),
	.bump_left(bump_left),
	.bump_right(bump_right),
	.ground(ground),
	.walk_left(walk_left),
	.walk_right(walk_right),
	.aaah(aaah)
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
    areset = 1; bump_left = 0; bump_right = 0; ground = 1;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    areset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 

    // scenario 2
    scenario = 2;
    bump_left = 1; ground = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    bump_left = 0;

    // scenario 3
    scenario = 3;
    bump_right = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    bump_right = 0;

    // scenario 4
    scenario = 4;
    ground = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    ground = 1;    

    // scenario 5
    scenario = 5;
    bump_left = 1; bump_right = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    bump_left = 0; bump_right = 0;

    // scenario 6
    scenario = 6;
    ground = 0; bump_left = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    ground = 1; bump_left = 0;

    // scenario 7
    scenario = 7;
    repeat(2) begin
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end

    // scenario 8
    scenario = 8;
    ground = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    ground = 1;    

    // scenario 9
    scenario = 9;
    bump_right = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    bump_right = 0;

    // scenario 10
    scenario = 10;
    ground = 0; bump_right = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, bump_left = %d, bump_right = %d, ground = %d, walk_left = %d, walk_right = %d, aaah = %d", scenario, clk, areset, bump_left, bump_right, ground, walk_left, walk_right, aaah);
        #10;
    end
    bump_right = 0;

    $fclose(file);
    $finish;
end

endmodule
