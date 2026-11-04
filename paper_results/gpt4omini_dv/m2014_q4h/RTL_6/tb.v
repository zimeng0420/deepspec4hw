module tb_top_module;
    reg in;
    wire out;

    // Instantiate the DUT
    top_module uut (
        .in(in),
        .out(out)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        in = 1'b0;   // Drive the input 'in' with value 0
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 1, in = %d, out = %d", in, out);
        #10;         // Hold it at 0 for an additional clock cycle
        $fdisplay(file, "scenario: 1a, in = %d, out = %d", in, out);

        // Scenario 2
        in = 1'b1;   // Change the input 'in' to 1
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 2, in = %d, out = %d", in, out);
        #10;         // Hold it at 1 for an additional clock cycle
        $fdisplay(file, "scenario: 2a, in = %d, out = %d", in, out);

        // Scenario 3
        in = 1'b0;   // Transition from 0 to 1 on 'in'
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 3, in = %d, out = %d", in, out);
        in = 1'b1;   // Change to 1
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 3a, in = %d, out = %d", in, out);
        #10;         // Hold at 1 for another clock cycle
        $fdisplay(file, "scenario: 3b, in = %d, out = %d", in, out);

        // Scenario 4
        in = 1'b1;   // Transition from 1 to 0 on 'in'
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 4, in = %d, out = %d", in, out);
        in = 1'b0;   // Change to 0
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 4a, in = %d, out = %d", in, out);
        #10;         // Hold at 0 for another clock cycle
        $fdisplay(file, "scenario: 4b, in = %d, out = %d", in, out);

        // Scenario 5
        in = 1'b0;   // Toggle input 'in' from 0 to 1
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 5, in = %d, out = %d", in, out);
        in = 1'b1;   // Change to 1
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 5a, in = %d, out = %d", in, out);
        in = 1'b0;   // Toggle back to 0
        #10;         // Wait for signals to stabilize
        $fdisplay(file, "scenario: 5b, in = %d, out = %d", in, out);

        // Close the output file
        $fclose(file);
        $finish;
    end
endmodule
