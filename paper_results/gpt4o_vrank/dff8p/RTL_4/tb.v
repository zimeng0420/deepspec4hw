`timescale 1ns / 1ps
module testbench;
reg  clk;
reg [7:0] d;
reg  reset;
wire [7:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.d(d),
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

    // scenario 1
    scenario = 1;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // hold reset high for 2 clock cycles
    reset = 0;
    d = 8'h00; // d = 0x00
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 

    // scenario 2
    scenario = 2;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // hold reset for 1 clock cycle
    reset = 0;
    d = 8'h12; // d = 0x12
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 

    // scenario 3
    scenario = 3;
    reset = 0;
    d = 8'h34; // d = 0x34
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // transition clk to 1
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // transition clk back to 0
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 

    // scenario 4
    scenario = 4;
    reset = 0;
    d = 8'hFF; // d = 0xFF
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // transition clk to 1
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // transition clk back to 0
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 

    // scenario 5
    scenario = 5;
    reset = 0;
    d = 8'hA5; // d = 0xA5
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // hold for 1 clock cycle
    reset = 1; // assert reset high
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // hold reset high for 1 cycle
    reset = 0; // set reset low again
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // output after the first clock edge following reset
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 
    
    d = 8'h7D; // change d to 0x7D
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // observe output at the negative edge of clk
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 

    // scenario 6
    scenario = 6;
    reset = 1; // apply reset high
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // hold for 2 clock cycles
    reset = 0; // set reset low
    d = 8'h10; // d = 0x10
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // observe q after transitioning clk to 0
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 

    // scenario 7
    scenario = 7;
    reset = 0; // keep reset low
    d = 8'h3C; // d = 0x3C
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // transition clk high
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // transition clk low
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // assert reset high for 1 cycle
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // set reset low again
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // observe output at next negative edge of clk
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 
    
    // scenario 8
    scenario = 8;
    reset = 0; // keep reset low
    d = 8'h5A; // d = 0x5A
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // transition clk high
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; // transition clk low
    d = 8'hC3; // change d to 0xC3
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; // observe output at negative edge of clk
    $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);

    $fclose(file);
    $finish;
end

endmodule
