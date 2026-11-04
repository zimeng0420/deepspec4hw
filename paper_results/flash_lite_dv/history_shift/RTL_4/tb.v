`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  predict_valid;
reg  predict_taken;
wire [31:0] predict_history;
reg  train_mispredicted;
reg  train_taken;
reg [31:0] train_history;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.areset(areset),
	.predict_valid(predict_valid),
	.predict_taken(predict_taken),
	.predict_history(predict_history),
	.train_mispredicted(train_mispredicted),
	.train_taken(train_taken),
	.train_history(train_history)
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
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    #10;
    areset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 

    // scenario 2
    scenario = 2;
    predict_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    #10;
    predict_taken = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 

    // scenario 3
    scenario = 3;
    predict_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 

    // scenario 4
    scenario = 4;
    train_mispredicted = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10;  
    predict_taken = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    predict_valid = 1;  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 

    // scenario 5
    scenario = 5;
    train_mispredicted = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10;  
    train_taken = 1; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10;  
    train_history = 32'hAABBCCDD; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    predict_valid = 0;  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 

    // scenario 6
    scenario = 6;
    predict_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10;  
    train_mispredicted = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    predict_taken = 1; 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 

    // scenario 7
    scenario = 7;
    predict_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10;  
    predict_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    repeat(4) begin
        #10;
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 
        predict_taken = predict_taken + 1; // Update predict_taken for each iteration
    end

    // scenario 8
    scenario = 8;
    train_mispredicted = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10;  
    train_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10;  
    train_history = 32'h11223344; 
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    predict_valid = 0;  
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); #10; 

    // scenario 9
    scenario = 9;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    #10;
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history); 
    #10;
    $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_taken = %d, predict_history = %d, train_mispredicted = %d, train_taken = %d, train_history = %d", scenario, clk, areset, predict_valid, predict_taken, predict_history, train_mispredicted, train_taken, train_history);

    $fclose(file);
    $finish;
end

endmodule
