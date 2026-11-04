`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  resetn;
reg  x;
reg  y;
wire  f;
wire  g;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.resetn(resetn),
	.x(x),
	.y(y),
	.f(f),
	.g(g)
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
    resetn = 0; // Assert resetn to 0
    repeat(1) begin
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end
    resetn = 1; // Assert resetn to 1
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(1) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end

    // Scenario 2
    scenario = 2;
    resetn = 1; // De-assert resetn
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(1) begin
        #10;
        x = 1; // Set x to 1
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    end
    repeat(1) begin
        #10;
        x = 0; // Set x to 0
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    end
    repeat(1) begin
        #10;
        x = 1; // Set x to 1
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end

    // Scenario 3
    scenario = 3;
    y = 0; // Set y to 0
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(2) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end
    y = 1; // Set y to 1 within 2 clock cycle window
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(1) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end

    // Scenario 4
    scenario = 4;
    y = 0; // Set y to 0
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(2) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end

    // Scenario 5
    scenario = 5;
    resetn = 1; // De-assert resetn
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(1) begin
        #10;
        x = 1; // Input x: 1
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    end
    repeat(1) begin
        #10;
        x = 0; // Input x: 0
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    end
    repeat(1) begin
        #10;
        x = 1; // Input x: 1
        $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    end
    // Wait for 3 clock cycles
    repeat(3) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end
    // Input x: 0, 1, 1;
    x = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(1) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end
    x = 1;
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(1) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    end
    x = 1; // Repeat to test state transitions and outputs
    repeat(3) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end

    // Scenario 6
    scenario = 6;
    resetn = 0; // Assert resetn to enter state A
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(1) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end
    resetn = 1; // De-assert resetn
    x = 1; // Input continuous stream of x = 1 for 5 clock cycles
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(5) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g); #10; 
    end
    x = 0; // Input x = 0 for 3 clock cycles
    $fdisplay(file, "scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    repeat(3) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, resetn = %d, x = %d, y = %d, f = %d, g = %d", scenario, clk, resetn, x, y, f, g);
    end

    $fclose(file);
    $finish;
end

endmodule
