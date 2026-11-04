`timescale 1ns / 1ps

module tb_top_module;

    // DUT output
    wire out;

    // Instantiate the DUT
    top_module DUT (
        .out(out)
    );

    // File descriptor for output file
    integer fd;

    initial begin
        // Open the output file
        fd = $fopen("TBout.txt", "w");
        
        // Scenario 1: Initialize the DUT at time t = 0 ns
        #0;
        $fdisplay(fd, "scenario: 1, out = %d", out);
        
        // Monitor output continuously during the first 100 ns
        #100; // Note: This gives a total of 100 ns from t = 0
        $fdisplay(fd, "scenario: 1a, out = %d", out);
        
        // Scenario 2: Stability check from t = 0 ns to t = 100 ns
        $display("Monitoring output stability from t=0 ns to t=100 ns: out = %d", out);
        
        // Check for stability during the first 100 ns
        if (out !== 0) begin
            $display("WARNING: Output 'out' transitioned during first 100 ns.");
        end

        // Scenario 3: Repeat for 200 ns
        #100; // Note: This gives a total of 200 ns from t = 0
        $fdisplay(fd, "scenario: 3, out = %d", out);
        
        // Check for stability during 100-200 ns
        if (out !== 0) begin
            $display("WARNING: Output 'out' transitioned during 200 ns.");
        end

        // Scenario 4: Check long-term behavior over 500 ns
        #300; // Note: This gives a total of 500 ns from t = 0
        $fdisplay(fd, "scenario: 4, out = %d", out);
        
        // Check for stability during 200-500 ns
        if (out !== 0) begin
            $display("WARNING: Output 'out' transitioned during 500 ns.");
        end

        // Scenario 5: Monitor output over 1000 ns
        repeat(10) begin
            #100; // Monitor intervals at every 100 ns
            $fdisplay(fd, "scenario: 5a, out = %d", out);
        end

        // Check for stability during the whole duration of 1000 ns
        $display("Ensuring no transitions occur on output 'out' during the entire 1000 ns duration.");

        // Final stability check during entire 1000 ns duration
        if (out !== 0) begin
            $display("WARNING: Output 'out' transitioned during the entire 1000 ns.");
        end

        // Close the output file
        $fclose(fd);
        // End the simulation
        $finish;
    end

endmodule
