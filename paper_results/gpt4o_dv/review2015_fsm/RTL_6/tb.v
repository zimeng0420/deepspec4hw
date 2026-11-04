`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg  data;
wire  shift_ena;
wire  counting;
reg  done_counting;
wire  done;
reg  ack;

integer file, scenario;

// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.data(data),
	.shift_ena(shift_ena),
	.counting(counting),
	.done_counting(done_counting),
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

    // scenario 1
    scenario = 1;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack); #10;
    end
    reset = 0;

    // scenario 2
    scenario = 2;
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 

    // Export the signals after scenario 2
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
        #10;
    end

    // scenario 3
    scenario = 3;
    repeat(4) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
        #10;
    end

    // scenario 4
    scenario = 4;
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 
    data = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 
    data = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 

    // Export the signals after scenario 4
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
        #10;
    end

    // scenario 5
    scenario = 5;
    done_counting = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 

    // Export the signals after scenario 5
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
        #10;
    end

    // scenario 6
    scenario = 6;
    repeat(1) begin
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
        #10;
    end

    // scenario 7
    scenario = 7;
    ack = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 

    // Export the signals after scenario 7
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
        #10;
    end
    ack = 0;

    // scenario 8
    scenario = 8;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
    #10; 

    // Export the final signals
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, shift_ena = %d, counting = %d, done_counting = %d, done = %d, ack = %d", scenario, clk, reset, data, shift_ena, counting, done_counting, done, ack);
        #10;
    end
    reset = 0;

    $fclose(file);
    $finish;
end

endmodule
