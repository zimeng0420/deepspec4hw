module tb_top_module;
    // Declare inputs and outputs
    reg in;
    wire out;

    // Instantiate the DUT
    top_module DUT (
        .in(in),
        .out(out)
    );

    // File handling
    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");
        
        // Scenario 1
        in = 0; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 1, in = %d, out = %d", in, out);
        
        // Scenario 2
        in = 1; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 2, in = %d, out = %d", in, out);
        
        // Scenario 3
        in = 0; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 3, in = %d, out = %d", in, out);
        
        // Scenario 4
        in = 1; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 4, in = %d, out = %d", in, out);
        
        // Scenario 5
        in = 1; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 5a, in = %d, out = %d", in, out);
        in = 0; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 5b, in = %d, out = %d", in, out);
        
        // Scenario 6
        in = 0; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 6a, in = %d, out = %d", in, out);
        in = 1; 
        #1; // Wait for 1 time unit
        $fdisplay(file, "scenario: 6b, in = %d, out = %d", in, out);
        
        // Close the file
        $fclose(file);
        
        // End the simulation
        $finish;
    end
endmodule
