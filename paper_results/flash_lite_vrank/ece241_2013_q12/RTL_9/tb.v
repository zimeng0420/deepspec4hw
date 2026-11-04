`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  enable;
reg  S;
reg  A;
reg  B;
reg  C;
wire  Z;

integer file, scenario;

// DUT instantiation
top_module DUT (
	.clk(clk),
	.enable(enable),
	.S(S),
	.A(A),
	.B(B),
	.C(C),
	.Z(Z)
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
    enable = 0; S = 0; A = 0; B = 0; C = 0;
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10;
    enable = 1; S = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;

    // Scenario 2
    scenario = 2;
    S = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Scenario 3
    scenario = 3;
    S = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Scenario 4
    scenario = 4;
    S = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Scenario 5
    scenario = 5;
    S = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Scenario 6
    scenario = 6;
    S = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Scenario 7
    scenario = 7;
    repeat(3) begin
        S = 1;  
        $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
        #10;
        S = 0;  
        $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
        #10;
    end

    // Scenario 8
    scenario = 8;
    S = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Scenario 9
    scenario = 9;
    repeat(2) begin
        S = 1;  
        $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
        #10;
        S = 0;  
        $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
        #10;
    end

    // Output Z from Q[0]
    scenario = 10;
    A = 0; B = 0; C = 0;
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Output Z from Q[3]
    scenario = 11;
    A = 0; B = 1; C = 1;
    $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z); #10; 

    // Continue changing A, B, C to cover all scenarios
    for (scenario = 12; scenario < 19; scenario = scenario + 1) begin
        {A, B, C} = scenario[2:0];
        $fdisplay(file, "scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, enable = %d, S = %d, A = %d, B = %d, C = %d, Z = %d", scenario, clk, enable, S, A, B, C, Z);
    end
    
    $fclose(file);
    $finish;
end

endmodule
