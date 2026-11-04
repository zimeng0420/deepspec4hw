`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg  w;
wire  z;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.w(w),
	.z(z)
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
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
        #10;
    end
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 2
    scenario = 2;
    w = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 3
    scenario = 3;
    w = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 4
    scenario = 4;
    w = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 5
    scenario = 5;
    w = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 6
    scenario = 6;
    w = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 7
    scenario = 7;
    w = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 8
    scenario = 8;
    w = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 9
    scenario = 9;
    w = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 10
    scenario = 10;
    w = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 11
    scenario = 11;
    w = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 12
    scenario = 12;
    w = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    // scenario 13
    scenario = 13;
    w = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, w = %d, z = %d", scenario, clk, reset, w, z);
    #10;

    $fclose(file);
    $finish;
end

endmodule
