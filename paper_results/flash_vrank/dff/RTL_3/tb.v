`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  d;
wire  q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.d(d),
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
    d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10;  // Wait for clock to go high
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 
    
    // Scenario 2
    scenario = 2;
    d = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10;  // Wait for clock to go high
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 
    
    // Scenario 3
    scenario = 3;
    d = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10;  // Wait for clock to go high
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // Scenario 4
    scenario = 4;
    d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10;  // Wait for clock to go high
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 
    
    // Scenario 5
    scenario = 5;
    d = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10;  // Wait for clock to go high
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 
    
    // Scenario 6
    scenario = 6;
    d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    repeat (5) begin
        #10; // waiting for clock edges
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 
    end

    // Scenario 7
    scenario = 7;
    d = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10;  // Wait for clock to go high
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 
    
    // Scenario 8
    scenario = 8;
    d = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10;  // Wait for clock to go high
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q);

    $fclose(file);
    $finish;
end

endmodule
