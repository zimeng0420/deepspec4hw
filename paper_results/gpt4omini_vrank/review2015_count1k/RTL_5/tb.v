`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
wire [9:0] q;

integer file, scenario;

// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
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
    reset = 1;  // Assert reset
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
    #10;        // Wait for 1 clock cycle
    reset = 0;  // Deassert reset
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q); #10; 
    
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
    #10; 
    
    // Scenario 2
    scenario = 2;
    repeat(1000) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    // Scenario 3
    scenario = 3;
    reset = 1;  // Assert reset
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
    #10;        // Wait for 1 clock cycle
    reset = 0;  // Deassert reset
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q); #10; 
    
    repeat(500) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    // Scenario 4
    scenario = 4;
    reset = 1;  // Assert reset at counter 500
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
    #10;        // Wait for 1 clock cycle
    reset = 0;  // Deassert reset
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q); #10; 
    
    repeat(100) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end
    
    reset = 1;  // Assert reset again
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
    #10;        // Wait for 1 clock cycle
    reset = 0;  // Deassert reset
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q); #10; 

    repeat(500) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    // Scenario 5
    scenario = 5;
    reset = 0;  // Hold the reset low
    repeat(999) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    // Check wrap around
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
    #10;

    // Scenario 6
    scenario = 6;
    reset = 0;  // Hold the reset low
    repeat(1500) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, q = %d", scenario, clk, reset, q);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
