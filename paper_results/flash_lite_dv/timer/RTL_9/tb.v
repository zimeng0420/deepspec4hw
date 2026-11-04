`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  load;
reg [9:0] data;
wire  tc;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.load(load),
	.data(data),
	.tc(tc)
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
    load = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    data = 10'b0000001010; 
    #10; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    #10; 
    load = 0;
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10; 
    
    // scenario 2
    scenario = 2;
    repeat(10) begin
        $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10; 
    end

    // scenario 3
    scenario = 3;
    load = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    data = 10'b0000000110; 
    #10; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10; 
    
    // scenario 4
    scenario = 4;
    load = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    #10; 
    repeat(6) begin
        $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10; 
    end

    // scenario 5
    scenario = 5;
    load = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    #10; 
    load = 1; 
    data = 10'b0000000000; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10; 

    // scenario 6
    scenario = 6;
    load = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc); #10; 

    // scenario 7
    scenario = 7;
    load = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);
    data = 10'b0000001001; 
    #10; 
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, tc = %d", scenario, clk, load, data, tc);

    $fclose(file);
    $finish;
end

endmodule
