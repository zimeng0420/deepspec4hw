`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  d;
reg  ar;
wire  q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.d(d),
	.ar(ar),
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
    ar = 1; d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10; 
    ar = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10; 
    
    // Scenario 2
    scenario = 2;
    ar = 0; d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10;
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
        #10;
    end
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10; 
    
    // Scenario 3
    scenario = 3;
    ar = 0; d = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10; 
    d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10; 
    
    // Scenario 4
    scenario = 4;
    ar = 0; d = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10; 
    
    // Scenario 5
    scenario = 5;
    ar = 0; d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10;
    repeat(2) begin
        $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10; 
        $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    end
    ar = 1;  
    #10; 
    ar = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q); #10; 
    
    // Scenario 6
    scenario = 6;
    ar = 0; d = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10; 
    d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, ar = %d, q = %d", scenario, clk, d, ar, q);
    
    $fclose(file);
    $finish;
end

endmodule
