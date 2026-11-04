`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  L;
reg  q_in;
reg  r_in;
wire  Q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.L(L),
	.q_in(q_in),
	.r_in(r_in),
	.Q(Q)
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
    L = 0; q_in = 0; r_in = 0;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    L = 1;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end

    // scenario 2
    scenario = 2;
    L = 1; q_in = 1; r_in = 0;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    L = 0;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end

    // scenario 3
    scenario = 3;
    L = 0; q_in = 0; r_in = 1;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end

    // scenario 4
    scenario = 4;
    L = 1; q_in = 0; r_in = 1;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end

    // scenario 5
    scenario = 5;
    L = 0; q_in = 1; r_in = 1;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end

    // scenario 6
    scenario = 6;
    L = 0; q_in = 0; r_in = 1;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    L = 1; q_in = 1;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end
    L = 0;

    // scenario 7
    scenario = 7;
    L = 1; q_in = 1; r_in = 0;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    L = 0;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end

    // scenario 8
    scenario = 8;
    L = 0; q_in = 1; r_in = 0;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
    #10;
    L = 1;
    $fdisplay(file, "scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, L = %d, q_in = %d, r_in = %d, Q = %d", scenario, clk, L, q_in, r_in, Q);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
