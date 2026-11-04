`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  in;
reg  areset;
wire  out;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.in(in),
	.areset(areset),
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
    areset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 

    // scenario 2
    scenario = 2; 
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    
    // scenario 3
    scenario = 3; 
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    
    // scenario 4
    scenario = 4; 
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    
    // scenario 5
    scenario = 5; 
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    
    // scenario 6
    scenario = 6; 
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end

    // scenario 7
    scenario = 7; 
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    
    // scenario 8
    scenario = 8; 
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    
    // scenario 9
    scenario = 9; 
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    
    // scenario 10
    scenario = 10; 
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
