`timescale 1ns / 1ps

module tb_top_module;

    // Parameters
    reg [99:0] in; // Input signals
    wire out_and;  // Output of AND gate
    wire out_or;   // Output of OR gate
    wire out_xor;  // Output of XOR gate

    // DUT instantiation
    top_module DUT (
        .in(in),
        .out_and(out_and),
        .out_or(out_or),
        .out_xor(out_xor)
    );

    // File handling
    integer file;

    // Initial block for test scenarios
    initial begin
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        in = 100'b0; 
        #10; 
        $fdisplay(file, "scenario: 1, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 2
        in = 100'b1; 
        #10; 
        $fdisplay(file, "scenario: 2, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 3
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
        #10;
        $fdisplay(file, "scenario: 3, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 4
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011;
        #10;
        $fdisplay(file, "scenario: 4, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 5
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111;
        #10;
        $fdisplay(file, "scenario: 5, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 6
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010; // Odd number of high inputs
        #10;
        $fdisplay(file, "scenario: 6, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 7
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001100; // Even number of high inputs
        #10;
        $fdisplay(file, "scenario: 7, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 8
        in = 100'b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111111111; // 50% inputs high
        #10;
        $fdisplay(file, "scenario: 8, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        
        // Scenario 9
        in = 100'b0101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101; // Even indices high
        #10;
        $fdisplay(file, "scenario: 9, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);

        // Scenario 10: Randomize inputs for clock cycles 10 through 20
        repeat (12) begin
            in = $random;
            #10;
            $fdisplay(file, "scenario: 10, in = %d, out_and = %d, out_or = %d, out_xor = %d", in, out_and, out_or, out_xor);
        end

        // Close the file
        $fclose(file);
        $finish;
    end
endmodule
