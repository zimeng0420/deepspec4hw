`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  x;
wire  z;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.areset(areset),
	.x(x),
	.z(z)
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

    // Scenario 1: Activate asynchronous reset
    scenario = 1;
    areset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end
    areset = 0;

    // Scenario 2: Drive x low while in state A
    scenario = 2;
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // Scenario 3: Drive x high while in state A
    scenario = 3;
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // Scenario 4: Drive x low while in state B
    scenario = 4;
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // Scenario 5: Drive x high while in state B
    scenario = 5;
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // Scenario 6: Toggle x while in state A
    scenario = 6;
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
        x = ~x;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    end

    // Scenario 7: Toggle x while in state B
    scenario = 7;
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
        x = ~x;
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    end

    // Scenario 8: Reactivate areset
    scenario = 8;
    areset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end
    areset = 0;

    // Scenario 9: Drive x high after resetting to state A
    scenario = 9;
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
