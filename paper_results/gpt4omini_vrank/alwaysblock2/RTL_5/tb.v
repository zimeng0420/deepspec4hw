`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  a;
reg  b;
wire  out_assign;
wire  out_always_comb;
wire  out_always_ff;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.a(a),
	.b(b),
	.out_assign(out_assign),
	.out_always_comb(out_always_comb),
	.out_always_ff(out_always_ff)
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
    a = 0; b = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff);
        #10;
    end

    // Scenario 2
    scenario = 2;
    a = 0; b = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff);
        #10;
    end

    // Scenario 3
    scenario = 3;
    a = 1; b = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff);
        #10;
    end

    // Scenario 4
    scenario = 4;
    a = 1; b = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff);
        #10;
    end

    // Scenario 5
    scenario = 5;
    a = 0; b = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff);
        #10;
    end
    a = 1; b = 1; $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10;

    // Scenario 6
    scenario = 6;
    a = 0; b = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff);
        #10;
    end
    a = 1; b = 0; $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10;

    // Scenario 7
    scenario = 7;
    a = 1; b = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, a = %d, b = %d, out_assign = %d, out_always_comb = %d, out_always_ff = %d", scenario, clk, a, b, out_assign, out_always_comb, out_always_ff);
        #10;
    end
    a = 0; b = 1; #10;

    $fclose(file);
    $finish;
end

endmodule
