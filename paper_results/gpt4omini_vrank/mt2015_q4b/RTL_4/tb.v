`timescale 1ns / 1ps
module testbench;
reg  x;
reg  y;
wire  z;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .x(x),
    .y(y),
    .z(z)
);

initial begin
    file = $fopen("TBout.txt", "w");
end
// Scenario Based Test
initial begin

    // scenario 1
    scenario = 1;
    x = 0; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 2
    scenario = 2;
    x = 0; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 3
    scenario = 3;
    x = 0; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 4
    scenario = 4;
    x = 0; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 5
    scenario = 5;
    x = 0; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 6
    scenario = 6;
    x = 1; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 7
    scenario = 7;
    x = 1; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 8
    scenario = 8;
    x = 0; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 9
    scenario = 9;
    x = 0; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 10
    scenario = 10;
    x = 1; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 11
    scenario = 11;
    x = 1; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 12
    scenario = 12;
    x = 0; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 13
    scenario = 13;
    x = 0; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 14
    scenario = 14;
    x = 0; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 15
    scenario = 15;
    x = 1; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 16
    scenario = 16;
    x = 0; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 17
    scenario = 17;
    x = 0; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 18
    scenario = 18;
    x = 0; y = 1;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    // scenario 19
    scenario = 19;
    x = 1; y = 0;  
    $fdisplay(file, "scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z); #10;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, x = %d, y = %d, z = %d", scenario, x, y, z);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
