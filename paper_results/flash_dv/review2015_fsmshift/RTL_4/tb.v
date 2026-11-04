`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
wire  shift_ena;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.shift_ena(shift_ena)
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
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
        #10;
    end
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;

    // scenario 2
    scenario = 2;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
        #10;
    end
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;

    // scenario 3
    scenario = 3;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
        #10;
    end
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;

    // scenario 4
    scenario = 4;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
        #10;
    end
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); #10;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
        #10;
    end

    // scenario 5
    scenario = 5;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    repeat(10) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); #10;
    end
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
        #10;
    end
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;

    // scenario 6
    scenario = 6;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
    #10;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena); 
    #10;
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, shift_ena = %d", scenario, clk, reset, shift_ena);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
