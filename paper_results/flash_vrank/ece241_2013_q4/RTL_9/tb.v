`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg [3:1] s;
wire  fr3;
wire  fr2;
wire  fr1;
wire  dfr;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.s(s),
	.fr3(fr3),
	.fr2(fr2),
	.fr1(fr1),
	.dfr(dfr)
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
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr); #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
        #10;
    end

    // scenario 2
    scenario = 2;
    s = 3'b000;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
    #10;
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
        #10;
    end

    // scenario 3
    scenario = 3;
    s = 3'b001;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
        #10;
    end

    // scenario 4
    scenario = 4;
    s = 3'b011;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
        #10;
    end

    // scenario 5
    scenario = 5;
    s = 3'b111;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
        #10;
    end

    // scenario 6
    scenario = 6;
    s = 3'b000;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr); #10; 

    // scenario 7
    scenario = 7;
    s = 3'b110;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
    #10;
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
        #10;
    end

    // scenario 8
    scenario = 8;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr); #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, s = %d, fr3 = %d, fr2 = %d, fr1 = %d, dfr = %d", scenario, clk, reset, s, fr3, fr2, fr1, dfr);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
