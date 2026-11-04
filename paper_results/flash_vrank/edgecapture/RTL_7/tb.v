`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg [31:0] in;
wire [31:0] out;

integer file, scenario;

// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.in(in),
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

    // scenario 1
    scenario = 1;
    in = 32'b00000000000000000000000000000000;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out); #10; 
    repeat(10) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
        #10;
    end
    reset = 0;

    // scenario 2
    scenario = 2;
    in = 32'b11111111111111111111111111111111;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;
    in = 32'b11111111111111111111111111111110;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;

    // scenario 3
    scenario = 3;
    in = 32'b10101010101010101010101010101010;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;
    in = 32'b10101010101010101010101010101000;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;

    // scenario 4
    scenario = 4;
    in = 32'b00000000000000000000000000000000;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;
    in = 32'b00000000000000000000000000000001;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;
    in = 32'b00000000000000000000000000000000;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;

    // scenario 5
    scenario = 5;
    in = 32'b01010101010101010101010101010101;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out); #10; 
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
        #10;
    end
    in = 32'b01010101010101010101010101010100;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;

    // scenario 6
    scenario = 6;
    reset = 1;
    in = 32'b00000000000000000000000000000000;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;
    reset = 0;
    in = 32'b00000000000000000000000000000001;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;
    in = 32'b00000000000000000000000000000000;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, out = %d", scenario, clk, reset, in, out);
    #10;

    $fclose(file);
    $finish;
end

endmodule
