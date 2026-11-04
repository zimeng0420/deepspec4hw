`timescale 1ns / 1ps
module testbench;
reg  clk;
reg [7:0] d;
reg  areset;
wire [7:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .clk(clk),
    .d(d),
    .areset(areset),
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
    areset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    d = 8'b10101010; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10; 

    // Scenario 2
    scenario = 2;
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    d = 8'b11110000; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10; 

    // Scenario 3
    scenario = 3;
    areset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10;
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    d = 8'b00001111; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10; 

    // Scenario 4
    scenario = 4;
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    d = 8'b00000000; 
    #10;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10; 

    // Scenario 5
    scenario = 5;
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    d = 8'b11111111; 
    #10;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    d = 8'b00000001; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10; 

    // Scenario 6
    scenario = 6;
    areset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10;
    d = 8'b01010101; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q); #10; 

    // Scenario 7
    scenario = 7;
    areset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    d = 8'b11001100; 
    #10;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);
    areset = 0; 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, areset = %d, q = %d", scenario, clk, d, areset, q);

    $fclose(file);
    $finish;
end

endmodule
