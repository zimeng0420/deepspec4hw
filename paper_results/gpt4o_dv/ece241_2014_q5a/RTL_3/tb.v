`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  x;
wire  z;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.areset(areset),
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

    // scenario 1
    scenario = 1;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // scenario 2
    scenario = 2;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // scenario 3
    scenario = 3;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    
    // scenario 4
    scenario = 4;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;

    // scenario 5
    scenario = 5;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(8) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
        x = ~x; // Alternate between 1 and 0
    end

    // scenario 6
    scenario = 6;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // scenario 7
    scenario = 7;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end
    x = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10; 
    repeat(9) begin
        x = (x == 1) ? 0 : 1; // Toggle x
        $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
    end

    // scenario 8
    scenario = 8;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); 
    #10;
    x = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z); #10;  
    repeat(16) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, x = %d, z = %d", scenario, clk, areset, x, z);
        #10;
        x = ~x; // Alternating bits
    end

    $fclose(file);
    $finish;
end

endmodule
