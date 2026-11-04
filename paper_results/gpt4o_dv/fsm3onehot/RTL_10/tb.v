`timescale 1ns / 1ps

module tb_top_module;

    reg in;
    reg [3:0] state;
    wire [3:0] next_state;
    wire out;

    // Instantiate DUT
    top_module DUT (
        .in(in),
        .state(state),
        .next_state(next_state),
        .out(out)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        state = 4'b0001;    // A
        in = 0;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 1, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 2
        in = 1;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 2, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 3
        state = 4'b0010;    // B
        in = 0;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 3, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 4
        in = 1;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 4, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 5
        state = 4'b0100;    // C
        in = 0;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 5, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 6
        in = 1;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 6, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 7
        state = 4'b1000;    // D
        in = 0;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 7, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 8
        in = 1;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 8, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 9
        state = 4'b0001;    // A
        in = 0;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 9, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        in = 1;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 9a, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Scenario 10
        state = 4'b0001;    // A
        in = 1;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 10, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        state = 4'b0010;    // B
        in = 0;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 10a, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);
        
        state = 4'b0100;    // C
        in = 1;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 10b, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        state = 4'b1000;    // D
        in = 0;             // Apply input
        #1;                 // Wait for signal stability
        $fdisplay(file, "scenario: 10c, in = %d, state = %d, next_state = %d, out = %d", in, state, next_state, out);

        // Close the file
        $fclose(file);
    end

endmodule
