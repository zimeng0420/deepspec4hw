`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  reset;
reg  data;
wire  start_shifting;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.reset(reset),
	.data(data),
	.start_shifting(start_shifting)
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
    reset = 1; data = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); 
    #10;
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(8) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
    end

    // scenario 2
    scenario = 2;
    data = 1; // start sending '1100'
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
        data = (clk % 20 < 10) ? 1 : 0; 
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    end

    // scenario 3
    scenario = 3;
    data = 1; // Send '1101'
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
        if (clk % 20 < 10) data = (clk % 30 == 20) ? 0 : 1; 
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    end

    // scenario 4
    scenario = 4;
    data = 0; // Continue sending '0000'
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    end

    // scenario 5
    scenario = 5;
    reset = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); 
    #10;
    reset = 0; data = 1; // Send '1101'
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
        if (clk % 20 < 10) data = (clk % 30 == 20) ? 0 : 1; 
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    end

    // scenario 6
    scenario = 6;
    reset = 0; 
    data = 1; // Start sending '11111000111011011100'
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(16) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
        if (clk % 40 < 10) data = 1; 
        else if (clk % 40 < 20) data = 0;
        else if (clk % 40 < 30) data = 1;
        else data = 0;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    end

    // scenario 7
    scenario = 7;
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(2) begin
        data = 1; // $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  Send '1111'
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10; 
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); 
        #10;
    end
    data = 1; // Start sending '1101'
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
        if (clk % 20 < 10) data = (clk % 30 == 20) ? 0 : 1; 
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    end

    // scenario 8
    scenario = 8;
    data = 1; // Immediately send '1111111111'
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    repeat(10) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting);
        #10;
        $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); #10;  
    end
    reset = 1; // Assert reset
    $fdisplay(file, "scenario: %d, clk = %d, reset = %d, data = %d, start_shifting = %d", scenario, clk, reset, data, start_shifting); 
    #10;

    $fclose(file);
    $finish;
end

endmodule
