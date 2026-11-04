`timescale 1ns / 1ps

module tb_top_module;

    reg [2:0] sel;
    reg [3:0] data0;
    reg [3:0] data1;
    reg [3:0] data2;
    reg [3:0] data3;
    reg [3:0] data4;
    reg [3:0] data5;
    wire [3:0] out;

    // Instantiate the DUT
    top_module DUT (
        .sel(sel),
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .data4(data4),
        .data5(data5),
        .out(out)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        sel = 3'b000; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 1, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 2
        sel = 3'b001; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 2, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 3
        sel = 3'b010; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 3, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 4
        sel = 3'b011; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 4, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 5
        sel = 3'b100; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 5, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 6
        sel = 3'b101; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 6, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 7
        sel = 3'b110; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 7, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 8
        sel = 3'b111; data0 = 4'b0001; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 8, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 9
        sel = 3'b011; data0 = 4'b1111; data1 = 4'b0010; data2 = 4'b0011; 
        data3 = 4'b0100; data4 = 4'b0101; data5 = 4'b0110; 
        #1; $fdisplay(file, "scenario: 9, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);
        
        // Scenario 10
        sel = 3'b100; data0 = 4'b0000; data1 = 4'b0000; 
        data2 = 4'b0000; data3 = 4'b0000; data4 = 4'b1111; 
        data5 = 4'b0000; 
        #1; $fdisplay(file, "scenario: 10, sel = %d, data0 = %d, data1 = %d, data2 = %d, data3 = %d, data4 = %d, data5 = %d, out = %d", sel, data0, data1, data2, data3, data4, data5, out);

        // Close the output file
        $fclose(file);
        $finish;
    end

endmodule
