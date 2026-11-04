`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg  data;
wire [3:0] count;
wire  counting;
wire  done;
reg  ack;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.data(data),
	.count(count),
	.counting(counting),
	.done(done),
	.ack(ack)
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
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 

    // Scenario 2
    scenario = 2;
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 
    
    // Scenario 3
    scenario = 3;
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 

    // Scenario 4
    scenario = 4;
    data = 0; // holding data low during count
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    repeat(1000) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 
    end

    // Scenario 5
    scenario = 5;
    data = 0; // holding data low
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 

    // Scenario 6
    scenario = 6;
    ack = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    ack = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 

    // Scenario 7
    scenario = 7;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 
    
    // Scenario 8
    scenario = 8;
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 

    // Scenario 9
    scenario = 9;
    data = 0; // holding data low during count
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    repeat(6000) begin
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 
    end

    // Scenario 10
    scenario = 10;
    ack = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);
    #10;
    ack = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack); #10; 
    $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, count = %d, counting = %d, done = %d, ack = %d", scenario, clk, reset, data, count, counting, done, ack);

    $fclose(file);
    $finish;
end

endmodule
