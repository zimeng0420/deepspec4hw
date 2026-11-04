`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg  in;
wire  disc;
wire  flag;
wire  err;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.in(in),
	.disc(disc),
	.flag(flag),
	.err(err)
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
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10;
    in = 0; repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10; // 0111110
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    
    // scenario 2
    scenario = 2;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10;
    in = 0; repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; 
    repeat(5) begin // 11111
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    
    // scenario 3
    scenario = 3;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10;
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; 
    repeat(7) begin // 1111111
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    
    // scenario 4
    scenario = 4;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10;
    in = 0; repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; 
    repeat(6) begin // 01111110
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    
    // scenario 5
    scenario = 5;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10;
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; 
    repeat(5) begin // 11111
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    
    // scenario 6
    scenario = 6;
    reset = 1; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; reset = 0; $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10;
    in = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err); #10; 
    repeat(8) begin // 11111111
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
        #10;
    end
    in = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, in = %d, disc = %d, flag = %d, err = %d", scenario, clk, reset, in, disc, flag, err);
    #10;
    $fclose(file);
    $finish;
end

endmodule
