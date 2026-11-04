`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  resetn;
reg [1:0] byteena;
reg [15:0] d;
wire [15:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.resetn(resetn),
	.byteena(byteena),
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
    resetn = 0; // Apply reset
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    #10;
    resetn = 1; // Release reset
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 2
    scenario = 2;
    byteena = 2'b00;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); 
    d = 16'hAAAA;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 3
    scenario = 3;
    byteena = 2'b01; // Lower byte enable
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); 
    d = 16'hFF00;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 4
    scenario = 4;
    byteena = 2'b10; // Upper byte enable
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); 
    d = 16'h00FF;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 5
    scenario = 5;
    byteena = 2'b11; // Both byte enables
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); 
    d = 16'h1234;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 6
    scenario = 6;
    byteena = 2'b01; 
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    d = 16'h0001;
    #10;
    byteena = 2'b10; 
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    d = 16'h1234;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 7
    scenario = 7;
    byteena = 2'b00; 
    d = 16'hFFFF;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); 
    repeat(3) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 
    end

    // Scenario 8
    scenario = 8;
    resetn = 0; // Apply reset
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    #10;
    resetn = 1; // Release reset
    byteena = 2'b01; 
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    d = 16'hABCD;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 9
    scenario = 9;
    byteena = 2'b01; 
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    d = 16'h5555;
    #10;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 
    byteena = 2'b10; 
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    d = 16'hAAAA;
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q); #10; 

    // Scenario 10
    scenario = 10;
    resetn = 1; // Start with resetn high
    byteena = 2'b11; 
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
    repeat(5) begin
        d = 16'h1A2B; // Different values can be assigned for d
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, byteena = %d, d = %d, q = %d", scenario, clk, resetn, byteena, d, q);
        resetn = 0; // Apply reset for one cycle
        #10;
        resetn = 1; 
    end

    $fclose(file);
    $finish;
end

endmodule
