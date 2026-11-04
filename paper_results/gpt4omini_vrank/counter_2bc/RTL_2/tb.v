`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  areset;
reg  train_valid;
reg  train_taken;
wire [1:0] state;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .clk(clk),
    .areset(areset),
    .train_valid(train_valid),
    .train_taken(train_taken),
    .state(state)
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
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    areset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); 
    #10;

    // scenario 2
    scenario = 2;
    train_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    train_taken = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    train_valid = 0;  
    train_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); 
    #10;

    // scenario 3
    scenario = 3;
    train_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    train_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    train_valid = 0;  
    train_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); 
    #10;

    // scenario 4
    scenario = 4;
    train_valid = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end

    // scenario 5
    scenario = 5;
    train_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    train_taken = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    train_valid = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end

    // scenario 6
    scenario = 6;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    areset = 0;  
    train_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    train_taken = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    train_valid = 0;  
    train_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); 
    #10;

    // scenario 7
    scenario = 7;
    areset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    areset = 0;  
    train_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    train_taken = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end
    train_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end

    // scenario 8
    scenario = 8;
    train_valid = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    train_taken = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, areset = %d, train_valid = %d, train_taken = %d, state = %d", scenario, clk, areset, train_valid, train_taken, state);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
