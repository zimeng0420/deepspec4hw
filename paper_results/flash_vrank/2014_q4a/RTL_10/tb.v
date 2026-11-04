`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  w;
reg  R;
reg  E;
reg  L;
wire  Q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.w(w),
	.R(R),
	.E(E),
	.L(L),
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
    // Scenario 1
    scenario = 1;
    E = 0; L = 0; R = 0; w = 0;
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10;
    end
    
    // Load test
    L = 1; R = 1;
    $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
    #10; 

    // Scenario 2
    scenario = 2;
    E = 1; L = 0; R = 0; w = 1;
    repeat(3) begin
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10;
    end

    // Scenario 3
    scenario = 3;
    w = 0;
    repeat(3) begin
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10;
    end

    // Scenario 4
    scenario = 4;
    E = 1; L = 1; R = 1; w = 0;
    $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
    #10; 

    // Scenario 5
    scenario = 5;
    E = 0; L = 1; R = 1;
    $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
    #10; 
    E = 1; L = 0; w = 0;
    repeat(2) begin
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10;
    end

    // Scenario 6
    scenario = 6;
    E = 1; L = 0; R = 0; w = 1;
    repeat(4) begin
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10;
    end
    E = 0; L = 0;
    repeat(3) begin
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10;
    end

    // Scenario 7
    scenario = 7;
    E = 1; L = 0; R = 1; w = 0;
    repeat(2) begin
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10; 
        L = 1; // Toggle L
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10; 
        L = 0; // Toggle back
    end

    // Scenario 8
    scenario = 8;
    E = 1; L = 0; R = 0; w = 0;
    repeat(3) begin
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10;
        w = 1; // Change w
        $fdisplay(file, "scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, w = %d, R = %d, E = %d, L = %d, Q = %d", scenario, clk, w, R, E, L, Q);
        #10; 
        w = 0; // Change w back
    end

    $fclose(file);
    $finish;
end

endmodule
