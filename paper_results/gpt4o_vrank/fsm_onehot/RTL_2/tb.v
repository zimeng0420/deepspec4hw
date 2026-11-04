`timescale 1ns / 1ps

module tb_top_module;
    
    // Parameters
    reg in;
    reg [9:0] state;
    wire [9:0] next_state;
    wire out1;
    wire out2;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .state(state),
        .next_state(next_state),
        .out1(out1),
        .out2(out2)
    );

    // File handling
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        state = 10'b0000000001; // S0
        in = 0; 
        #1; // Delay for stability
        $fdisplay(file, "scenario: 1, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 1 failed!");

        // Scenario 2
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 2, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000010) $error("Scenario 2 failed!");

        // Scenario 3
        state = 10'b0000000010; // S1
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 3, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 3 failed!");

        // Scenario 4
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 4, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000100) $error("Scenario 4 failed!");

        // Scenario 5
        state = 10'b0000000100; // S2
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 5, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 5 failed!");

        // Scenario 6
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 6, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000001000) $error("Scenario 6 failed!");

        // Scenario 7
        state = 10'b0000001000; // S3
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 7, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 7 failed!");

        // Scenario 8
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 8, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000010000) $error("Scenario 8 failed!");

        // Scenario 9
        state = 10'b0000010000; // S4
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 9, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 9 failed!");

        // Scenario 10
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 10, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000100000) $error("Scenario 10 failed!");

        // Scenario 11
        state = 10'b0000100000; // S5
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 11, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000010000) $error("Scenario 11 failed!");

        // Scenario 12
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 12, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0001000000) $error("Scenario 12 failed!");

        // Scenario 13
        state = 10'b0001000000; // S6
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 13, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000100000) $error("Scenario 13 failed!");

        // Scenario 14
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 14, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0010000000) $error("Scenario 14 failed!");

        // Scenario 15
        state = 10'b0010000000; // S7
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 15, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 15 failed!");
        if (out2 !== 1) $error("Scenario 15 failed (out2 should be 1)!");

        // Scenario 16
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 16, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0010000000) $error("Scenario 16 failed!");

        // Scenario 17
        state = 10'b0100000000; // S8
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 17, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 17 failed!");
        if (out1 !== 1) $error("Scenario 17 failed (out1 should be 1)!");

        // Scenario 18
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 18, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000010) $error("Scenario 18 failed!");

        // Scenario 19
        state = 10'b1000000000; // S9
        in = 0; 
        #1; 
        $fdisplay(file, "scenario: 19, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000001) $error("Scenario 19 failed!");
        if (out1 !== 1) $error("Scenario 19 failed (out1 should be 1)!");

        // Scenario 20
        in = 1; 
        #1; 
        $fdisplay(file, "scenario: 20, in = %d, state = %d, next_state = %d, out1 = %d, out2 = %d", in, state, next_state, out1, out2);
        // Verify
        if (next_state !== 10'b0000000010) $error("Scenario 20 failed!");
        
        // Close the file
        $fclose(file);
        $finish;
    end

endmodule
