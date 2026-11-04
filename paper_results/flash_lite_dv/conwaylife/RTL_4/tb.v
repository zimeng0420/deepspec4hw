`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  load;
reg [255:0] data;
wire [255:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
    .clk(clk),
    .load(load),
    .data(data),
    .q(q)
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
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'h0000000000000000000000000000000000000000000000000000000000000000;
    #10;
    load = 0;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10; 

    // scenario 2
    scenario = 2;
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'h0000000000000000000000000000000000000000000000000000000000000400;
    #10;
    load = 0;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10; 

    // scenario 3
    scenario = 3;
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'h0000000000000000000000000000000008000000002000000000400000000000;
    #10;
    load = 0;  
    repeat(4) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
        #10;
    end

    // scenario 4
    scenario = 4;
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'h0000000000000000000000000000000000000000000F00000000000000000000;
    #10;
    load = 0;  
    repeat(6) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
        #10;
    end

    // scenario 5
    scenario = 5;
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'h00000000000000000000000000000000000000000000F000F00000000000000;
    #10;
    load = 0;  
    $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q); #10; 

    // scenario 6
    scenario = 6;
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'h0000000000000000000000000000000000000000000600000000000000000000;
    #10;
    load = 0;  
    repeat(2) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
        #10;
    end

    // scenario 7
    scenario = 7;
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'hA3F4C7D06916D4F1C0DB9A816ABF1708D2E554003C6C7D32D173AE16E4804D;
    #10;
    load = 0;  
    repeat(5) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
        #10;
    end

    // scenario 8
    scenario = 8;
    load = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);  
    data = 256'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    #10;
    load = 0;  
    repeat(3) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, load = %d, data = %d, q = %d", scenario, clk, load, data, q);
        #10;
    end

    $fclose(file);
    $finish;
end

endmodule
