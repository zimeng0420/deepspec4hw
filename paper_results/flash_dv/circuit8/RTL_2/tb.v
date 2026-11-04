`timescale 1ns / 1ps
module testbench;
reg  clock;
reg  a;
wire  p;
wire  q;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .clock(clock),
    .a(a),
    .p(p),
    .q(q)
);
// Clock generation
initial begin
    clock = 0;
    forever #5 clock = ~clock;
end

initial begin
    file = $fopen("TBout.txt", "w");
end
// Scenario Based Test
initial begin

    // Scenario 1
    scenario = 1;
    a = 0;  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 2
    scenario = 2;
    a = 0;  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(6) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 3
    scenario = 3;
    a = 0;  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end
    a = 1; // Change a to 1 at 70ns  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end
    a = 0; // Change a back to 0 at 75ns  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 4
    scenario = 4;
    a = 1; // a transitions to 1 at 80ns   
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 5
    scenario = 5;
    a = 0;  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 6
    scenario = 6;
    a = 1; // a transitions to 1 at 90ns  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 7
    scenario = 7;
    a = 1; // Maintain a at 1 until clock rises again  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 8
    scenario = 8;
    a = 1; // Maintain a at 1 while clock is high   
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 9
    scenario = 9;
    a = 1; // Maintain a at 1 until clock rises again  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 10
    scenario = 10;
    a = 1; // Maintain a at 1 until clock falls  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 11
    scenario = 11;
    a = 0; // a transitions to 0 at 120ns  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 12
    scenario = 12;
    a = 0; // Maintain a at 0 and then set to 1 at 175ns 
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end
    a = 1; // Change a to 1 at 175ns   
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 13
    scenario = 13;
    a = 0; // Maintain a at 0 until clock rises at 185ns  
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    // Scenario 14
    scenario = 14;
    a = 1; // a transitions to 1 at 185ns   
    $fdisplay(file, "scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q); #10;  
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clock = %d, a = %d, p = %d, q = %d", scenario, clock, a, p, q);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
