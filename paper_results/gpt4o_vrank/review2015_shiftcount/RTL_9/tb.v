`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  shift_ena;
reg  count_ena;
reg  data;
wire [3:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .clk(clk),
    .shift_ena(shift_ena),
    .count_ena(count_ena),
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
    shift_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    data = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    repeat(4) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 
    end

    // Scenario 2
    scenario = 2;
    shift_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    data = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    repeat(4) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 
    end

    // Scenario 3
    scenario = 3;
    shift_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    repeat(5) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 
    end

    // Scenario 4
    scenario = 4;
    shift_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    repeat(4) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 
    end

    // Scenario 5
    scenario = 5;
    shift_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    data = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 
    
    data = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 

    // Scenario 6
    scenario = 6;
    shift_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    
    shift_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    data = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 

    // Scenario 7
    scenario = 7;
    shift_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    data = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    repeat(3) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10; 
    end

    // Scenario 8
    scenario = 8;
    shift_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    
    shift_ena = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    count_ena = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q); #10;   
    data = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, shift_ena = %d, count_ena = %d, data = %d, q = %d", scenario, clk, shift_ena, count_ena, data, q);
    
    $fclose(file);
    $finish;
end

endmodule
