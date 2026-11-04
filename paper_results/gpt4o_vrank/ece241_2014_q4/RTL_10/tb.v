`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  x;
wire  z;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.x(x),
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
    // Scenario 1
    scenario = 1;
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end
    
    // Scenario 2
    scenario = 2;
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end

    // Scenario 3
    scenario = 3;
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end

    // Scenario 4
    scenario = 4;
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
    #10;
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
    #10;
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end

    // Scenario 5
    scenario = 5;
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end
    
    // Scenario 6
    scenario = 6;
    x = 0;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z); #10; 
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, x = %d, z = %d", scenario, clk, x, z);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
