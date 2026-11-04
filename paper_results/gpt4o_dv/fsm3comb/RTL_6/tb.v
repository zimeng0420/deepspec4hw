`timescale 1ns / 1ps

module tb_top_module;
    reg in;
    reg [1:0] state;
    wire [1:0] next_state;
    wire out;
    
    // Instance of the DUT (Device Under Test)
    top_module DUT (
        .in(in),
        .state(state),
        .next_state(next_state),
        .out(out)
    );
    
    // File handle
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1: Set the initial state to A (2'b00) and input in to 0. Wait for one clock cycle.
        state = 2'b00; // A
        in = 1'b0;
        #10;
        $fdisplay(file, "scenario: 1, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        // Scenario 2: Set the current state to A (2'b00) and input in to 1. Wait for one clock cycle.
        state = 2'b00; // A
        in = 1'b1;
        #10;
        $fdisplay(file, "scenario: 2, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        // Scenario 3: Set the current state to B (2'b01) and input in to 0. Wait for one clock cycle.
        state = 2'b01; // B
        in = 1'b0;
        #10;
        $fdisplay(file, "scenario: 3, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        // Scenario 4: Set the current state to B (2'b01) and input in to 1. Wait for one clock cycle.
        state = 2'b01; // B
        in = 1'b1;
        #10;
        $fdisplay(file, "scenario: 4, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        // Scenario 5: Set the current state to C (2'b10) and input in to 0. Wait for one clock cycle.
        state = 2'b10; // C
        in = 1'b0;
        #10;
        $fdisplay(file, "scenario: 5, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        // Scenario 6: Set the current state to C (2'b10) and input in to 1. Wait for one clock cycle.
        state = 2'b10; // C
        in = 1'b1;
        #10;
        $fdisplay(file, "scenario: 6, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        // Scenario 7: Set the current state to D (2'b11) and input in to 0. Wait for one clock cycle.
        state = 2'b11; // D
        in = 1'b0;
        #10;
        $fdisplay(file, "scenario: 7, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        // Scenario 8: Set the current state to D (2'b11) and input in to 1. Wait for one clock cycle.
        state = 2'b11; // D
        in = 1'b1;
        #10;
        $fdisplay(file, "scenario: 8, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Close the output file
        $fclose(file);
        
        // End the simulation
        $finish;
    end
endmodule
