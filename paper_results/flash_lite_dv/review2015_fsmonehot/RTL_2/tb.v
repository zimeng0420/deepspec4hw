`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg d;
    reg done_counting;
    reg ack;
    reg [9:0] state;

    // Outputs
    wire B3_next;
    wire S_next;
    wire S1_next;
    wire Count_next;
    wire Wait_next;
    wire done;
    wire counting;
    wire shift_ena;

    // Instantiate the DUT
    top_module DUT (
        .d(d),
        .done_counting(done_counting),
        .ack(ack),
        .state(state),
        .B3_next(B3_next),
        .S_next(S_next),
        .S1_next(S1_next),
        .Count_next(Count_next),
        .Wait_next(Wait_next),
        .done(done),
        .counting(counting),
        .shift_ena(shift_ena)
    );

    // File handling
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        d = 0; done_counting = 0; ack = 0; state = 10'b0000000001; #10;
        $fdisplay(file, "scenario: 1, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 2
        d = 1; done_counting = 0; ack = 0; state = 10'b0000000001; #10;
        $fdisplay(file, "scenario: 2, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);
    
        // Scenario 3
        d = 1; done_counting = 0; ack = 0; state = 10'b0000000010; #10;
        $fdisplay(file, "scenario: 3, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);
    
        // Scenario 4
        d = 0; done_counting = 0; ack = 0; state = 10'b0000000010; #10;
        $fdisplay(file, "scenario: 4, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);
    
        // Scenario 5
        d = 1; done_counting = 0; ack = 0; state = 10'b0000000010; #10;
        $fdisplay(file, "scenario: 5, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);
    
        // Scenario 6
        d = 0; done_counting = 0; ack = 0; state = 10'b0000000100; #10;
        $fdisplay(file, "scenario: 6, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);
    
        // Scenario 7
        d = 1; done_counting = 0; ack = 0; state = 10'b0000000100; #10;
        $fdisplay(file, "scenario: 7, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);
    
        // Scenario 8
        d = 0; done_counting = 0; ack = 0; state = 10'b0000001000; #10;
        $fdisplay(file, "scenario: 8, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 9
        d = 1; done_counting = 0; ack = 0; state = 10'b0000001000; #10;
        $fdisplay(file, "scenario: 9, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 10
        d = 0; done_counting = 0; ack = 0; state = 10'b0000010000; #10;
        $fdisplay(file, "scenario: 10, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 11
        d = 1; done_counting = 0; ack = 0; state = 10'b0000010000; #10;
        $fdisplay(file, "scenario: 11, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 12
        d = 0; done_counting = 0; ack = 0; state = 10'b0000100000; #10;
        $fdisplay(file, "scenario: 12, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 13
        d = 1; done_counting = 0; ack = 0; state = 10'b0000100000; #10;
        $fdisplay(file, "scenario: 13, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 14
        d = 0; done_counting = 0; ack = 0; state = 10'b0001000000; #10;
        $fdisplay(file, "scenario: 14, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 15
        d = 1; done_counting = 0; ack = 0; state = 10'b0001000000; #10;
        $fdisplay(file, "scenario: 15, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 16
        d = 1; done_counting = 0; ack = 0; state = 10'b0010000000; #10;
        $fdisplay(file, "scenario: 16, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 17
        d = 0; done_counting = 0; ack = 0; state = 10'b0100000000; #10;
        $fdisplay(file, "scenario: 17, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 18
        d = 0; done_counting = 1; ack = 0; state = 10'b0100000000; #10;
        $fdisplay(file, "scenario: 18, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 19
        d = 0; done_counting = 1; ack = 0; state = 10'b1000000000; #10;
        $fdisplay(file, "scenario: 19, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Scenario 20
        d = 0; done_counting = 1; ack = 1; state = 10'b1000000000; #10;
        $fdisplay(file, "scenario: 20, d = %d, done_counting = %d, ack = %d, state = %b, B3_next = %d, S_next = %d, S1_next = %d, Count_next = %d, Wait_next = %d, done = %d, counting = %d, shift_ena = %d", d, done_counting, ack, state, B3_next, S_next, S1_next, Count_next, Wait_next, done, counting, shift_ena);

        // Close the output file
        $fclose(file);
    end

endmodule
