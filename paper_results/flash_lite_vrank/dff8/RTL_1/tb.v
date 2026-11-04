`timescale 1ns / 1ps
module testbench;
reg  clk;
reg [7:0] d;
wire [7:0] q;

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
    // scenario 1
    scenario = 1;
    d = 8'b00000001;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // scenario 2
    scenario = 2;
    d = 8'b11111111;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // scenario 3
    scenario = 3;
    d = 8'b10101010;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // scenario 4
    scenario = 4;
    d = 8'b00110011;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // scenario 5
    scenario = 5;
    d = 8'b01010101;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // scenario 6
    scenario = 6;
    d = 8'b10011001;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // scenario 7
    scenario = 7;
    d = 8'b01100110;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); #10; 

    // scenario 8
    scenario = 8;
    d = 8'b11001100;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q); 
    #10; // wait for clk edge
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, q = %d", scenario, clk, d, q);
    
    $fclose(file);
    $finish;
end

endmodule
