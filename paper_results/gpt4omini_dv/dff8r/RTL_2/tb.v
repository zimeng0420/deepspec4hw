`timescale 1ns / 1ps
module testbench;
reg  clk;
reg [7:0] d;
reg  reset;
wire [7:0] q;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.d(d),
	.reset(reset),
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
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10; 
    reset = 0; 
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10;
    end

    // scenario 2
    scenario = 2;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    d = 8'b10101010;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b11110000;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end

    // scenario 3
    scenario = 3;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    d = 8'b00000000;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b11111111;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end

    // scenario 4
    scenario = 4;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    d = 8'b00001111;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end

    // scenario 5
    scenario = 5;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    d = 8'b00000001;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b11111111;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b10101010;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end

    // scenario 6
    scenario = 6;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    d = 8'b00000001;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b00000010;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b00000011;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end

    // scenario 7
    scenario = 7;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    d = 8'b10101010;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b11001100;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end

    // scenario 8
    scenario = 8;
    reset = 1;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q); #10;
    reset = 0;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    d = 8'b11111111;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end
    d = 8'b00000000;  
    $fdisplay(file, "scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
    #10;
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, d = %d, reset = %d, q = %d", scenario, clk, d, reset, q);
        #10; 
    end

    $fclose(file);
    $finish;
end

endmodule
