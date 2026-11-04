`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  in;
reg  areset;
wire  out;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.in(in),
	.areset(areset),
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

    // Scenario 1
    scenario = 1;
    areset = 1; // Reset high
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    areset = 0; // Reset low
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end

    // Scenario 2
    scenario = 2;
    areset = 0; // Maintain state B
    in = 0; // Input 0 at cycle 1
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    in = 1; // Input 1 at cycle 3
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end

    // Scenario 3
    scenario = 3;
    areset = 0; // Maintain state B
    in = 1; // Input 1 at cycle 1
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    in = 0; // Input 0 at cycle 3
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end

    // Scenario 4
    scenario = 4;
    areset = 1; // Reset high at cycle 0
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    areset = 0; // Reset low
    in = 0; // Input 0 at cycle 2
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    in = 1; // Input 1 at cycle 4
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end

    // Scenario 5
    scenario = 5;
    areset = 0; // Maintain state B
    in = 0; // Input 0 at cycle 1
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end
    in = 0; // Input 0 at cycle 3
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, areset = %d, out = %d", scenario, clk, in, areset, out);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
