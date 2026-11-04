`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg [2:0] vec;

    // Outputs
    wire [2:0] outv;
    wire o2;
    wire o1;
    wire o0;

    // Instantiate the DUT
    top_module DUT (
        .vec(vec),
        .outv(outv),
        .o2(o2),
        .o1(o1),
        .o0(o0)
    );

    // File handling
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        vec = 3'b000;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 1, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Scenario 2
        vec = 3'b001;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 2, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Scenario 3
        vec = 3'b010;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 3, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Scenario 4
        vec = 3'b011;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 4, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Scenario 5
        vec = 3'b100;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 5, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Scenario 6
        vec = 3'b101;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 6, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Scenario 7
        vec = 3'b110;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 7, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Scenario 8
        vec = 3'b111;
        #1; // wait for 1 time unit
        $fdisplay(file, "scenario: 8, vec = %d, outv = %d, o2 = %d, o1 = %d, o0 = %d", vec, outv, o2, o1, o0);

        // Close the file
        $fclose(file);
        
        // Finish simulation
        $finish;
    end

endmodule
