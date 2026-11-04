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

    // Scenario 1: Hold the reset signal high for one clock cycle and then set it low to transition the DUT to state B.
    scenario = 1;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 2: Set 'in' to 0 for one clock cycle while in state B and observe state transition.
    scenario = 2;
    in = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 3: Set 'in' to 1 for one clock cycle while in state B and observe output (should remain in state B).
    scenario = 3;
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 4: Set 'in' to 1 for one clock cycle while in state A and observe output (should remain in state A).
    scenario = 4;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;  // Transition to state B
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 5: Set 'in' to 0 for one clock cycle while in state A to transition to state B.
    scenario = 5;
    in = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 6: Toggle the 'in' signal by setting it to 1 for one clock cycle followed by 0 for one clock cycle while in state A.
    scenario = 6;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;  // Transition to state B
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    in = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 7: Set 'in' to 0 for two consecutive clock cycles while in state B and observe if the state transitions correctly to A and output changes.
    scenario = 7;
    in = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 8: Set 'in' to 0 for two consecutive clock cycles while in state A and observe if the state transitions back to B and output changes.
    scenario = 8;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10;  // Transition to state B
    in = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;  // Transition to A
    in = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10; 
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); #10; 
    
    // Scenario 9: Pulse the reset signal high for one clock cycle while either in state A or state B and observe that the state machine returns to state B.
    scenario = 9;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10; 
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out = %d", scenario, clk, in, reset, out);
    
    $fclose(file);
    $finish;
end

endmodule
