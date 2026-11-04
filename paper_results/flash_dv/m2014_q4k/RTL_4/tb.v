`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  resetn;
reg  in;
wire  out;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.resetn(resetn),
	.in(in),
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
    resetn = 0; in = 0;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; // Wait for one clock cycle
    resetn = 1; // Release reset
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 

    // scenario 2
    scenario = 2;
    resetn = 1; in = 0;
    repeat(4) begin
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
    end

    // scenario 3
    scenario = 3;
    resetn = 1; in = 1;
    repeat(4) begin
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
    end

    // scenario 4
    scenario = 4;
    resetn = 1; in = 1;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; // Toggle clk for 1 cycle
    in = 0; // Change in
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    repeat(3) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
    end

    // scenario 5
    scenario = 5;
    resetn = 0; in = 0;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; // Wait for one clock cycle
    resetn = 1; in = 1; // Set resetn and in
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    repeat(4) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
    end

    // scenario 6
    scenario = 6;
    resetn = 1; in = 0;
    repeat(2) begin
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    end
    in = 1; // Change in to 1
    repeat(3) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
    end

    // scenario 7
    scenario = 7;
    resetn = 1; in = 0;
    repeat(4) begin
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    end
    in = 1; // Change in to 1
    #10;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 

    // scenario 8
    scenario = 8;
    resetn = 1; in = 1;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; // Toggle clk for 1 cycle
    resetn = 0; // Active low reset
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    #10; // Toggle clk for 1 cycle
    $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 

    // scenario 9
    scenario = 9;
    resetn = 0; in = 0;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; // Toggle clk for 1 cycle
    resetn = 1; // Release reset
    in = 1; // Set in to 1
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    repeat(4) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        in = ~in; // Alternate in
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
    end

    // scenario 10
    scenario = 10;
    resetn = 1; in = 1;
    repeat(3) begin
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    end
    in = 0; // Change in to 0
    repeat(3) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, in = %d, out = %d", scenario, clk, resetn, in, out);
    end

    $fclose(file);
    $finish;
end

endmodule
