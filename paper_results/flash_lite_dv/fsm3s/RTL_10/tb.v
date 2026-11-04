`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  in;
reg  reset;
wire  out;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.in(in),
	.reset(reset),
	.out(out)
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
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);  
    #10;

    // scenario 2
    scenario = 2;
    in = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);  
    repeat(2) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;   
    end
    
    // scenario 3
    scenario = 3;
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);  
    #10;
    
    // scenario 4
    scenario = 4;
    in = 0;  
    repeat(2) begin
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;   
    end
    
    // scenario 5
    scenario = 5;
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);  
    #10;
    
    // scenario 6
    scenario = 6;
    in = 0;  
    repeat(2) begin
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;   
    end
    
    // scenario 7
    scenario = 7;
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);  
    #10;
    
    // scenario 8
    scenario = 8;
    in = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;   
    
    // scenario 9
    scenario = 9;
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;   
    
    // scenario 10
    scenario = 10;
    in = 0;  
    repeat(2) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);  
    end

    $fclose(file);
    $finish;
end

endmodule
