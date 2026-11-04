`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  predict_valid;
reg [6:0] predict_pc;
wire  predict_taken;
wire [6:0] predict_history;
reg  train_valid;
reg  train_taken;
reg  train_mispredicted;
reg [6:0] train_history;
reg [6:0] train_pc;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.areset(areset),
	.predict_valid(predict_valid),
	.predict_pc(predict_pc),
	.predict_taken(predict_taken),
	.predict_history(predict_history),
	.train_valid(train_valid),
	.train_taken(train_taken),
	.train_mispredicted(train_mispredicted),
	.train_history(train_history),
	.train_pc(train_pc)
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
    areset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10;
    areset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 2
    scenario = 2;
    predict_valid = 1;
    predict_pc = 7'b0000001;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 3
    scenario = 3;
    predict_pc = 7'b0000010;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 4
    scenario = 4;
    train_valid = 1;
    train_pc = 7'b0000001;
    train_taken = 1'b1;
    train_mispredicted = 1'b0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 5
    scenario = 5;
    train_valid = 0;
    predict_valid = 0;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 6
    scenario = 6;
    train_valid = 1;
    train_pc = 7'b0000010;
    train_taken = 1'b0;
    train_mispredicted = 1'b1;
    predict_valid = 1;
    predict_pc = 7'b0000001;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 7
    scenario = 7;
    predict_valid = 1;
    predict_pc = 7'b0000011;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 8
    scenario = 8;
    train_valid = 1;
    train_pc = 7'b0000011;
    train_taken = 1'b1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 9
    scenario = 9;
    predict_valid = 1;
    predict_pc = 7'b0000000;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    // Scenario 10
    scenario = 10;
    areset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, predict_valid = %d, predict_pc = %d, predict_taken = %d, predict_history = %d, train_valid = %d, train_taken = %d, train_mispredicted = %d, train_history = %d, train_pc = %d", scenario, clk, areset, predict_valid, predict_pc, predict_taken, predict_history, train_valid, train_taken, train_mispredicted, train_history, train_pc);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
