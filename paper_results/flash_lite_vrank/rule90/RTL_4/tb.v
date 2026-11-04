`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  load;
reg [511:0] data;
wire [511:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.load(load),
	.data(data),
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
    load = 0;
    data = 512'b0000000000000000000000000000000000000000000000000000000000000000; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;

    // Scenario 2
    scenario = 2;
    load = 1;
    data = 512'b1010101010101010101010101010101010101010101010101010101010101010; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10; 
    load = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    
    // Scenario 3
    scenario = 3;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;   
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10; 
    
    // Scenario 4
    scenario = 4;
    load = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    
    // Scenario 5
    scenario = 5;
    repeat(10) begin
        $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10; 
    end
    
    // Scenario 6
    scenario = 6;
    load = 1;
    data = 512'b1111111111111111111111111111111111111111111111111111111111111111; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    repeat(4) begin
        #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10; 
    end

    // Scenario 7
    scenario = 7;
    load = 0; 
    data = 512'b1011100100110100101011000111100100010011001011110101110101010110; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;

    // Scenario 8
    scenario = 8;
    load = 1;
    data = 512'b0000000000000000000000000000000000000000000000000000000000000001; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
    #10;

    $fclose(file);
    $finish;
end

endmodule
