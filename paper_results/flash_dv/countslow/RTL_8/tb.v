`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  slowena;
reg  reset;
wire [3:0] q;

integer file, scenario;

// DUT instantiation
top_module DUT (
	.clk(clk),
	.slowena(slowena),
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
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 

    // Scenario 2
    scenario = 2;
    slowena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    repeat(10) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 
    end
    slowena = 0;

    // Scenario 3
    scenario = 3;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 

    // Scenario 4
    scenario = 4;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 

    // Scenario 5
    scenario = 5;
    slowena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    repeat(5) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    end
    slowena = 0;
    #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10;
    repeat(5) begin
        $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10;
        $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 
    end

    // Scenario 6
    scenario = 6;
    slowena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 

    // Scenario 7
    scenario = 7;
    reset = 1;
    slowena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10;
    reset = 0;
    slowena = 0;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q); #10; 

    // Scenario 8
    scenario = 8;
    reset = 1;
    slowena = 1;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);
    slowena = 0;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, slowena = %d, reset = %d, q = %d", scenario, clk, slowena, reset, q);

    $fclose(file);
    $finish;
end

endmodule
