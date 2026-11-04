`timescale 1ns/1ps

module tb_top_module;

    // Output signal from DUT
    wire zero;

    // Instantiate the DUT
    top_module dut (
        .zero(zero)
    );

    // File descriptor for output
    integer fd;

    initial begin
        // Open the output file
        fd = $fopen("TBout.txt", "w");

        // Scenario 1: monitor at clock cycle 0
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 1, zero = %d", zero);

        // Scenario 2: monitor at clock cycle 1
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 2, zero = %d", zero);

        // Scenario 3: monitor at clock cycle 2
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 3, zero = %d", zero);

        // Scenario 4: monitor at clock cycle 3
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 4, zero = %d", zero);

        // Scenario 5: monitor at clock cycle 4
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 5, zero = %d", zero);

        // Scenario 6: monitor at clock cycle 5
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 6, zero = %d", zero);

        // Scenario 7: monitor at clock cycle 6
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 7, zero = %d", zero);

        // Scenario 8: monitor at clock cycle 7
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 8, zero = %d", zero);

        // Scenario 9: monitor at clock cycle 8
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 9, zero = %d", zero);

        // Scenario 10: monitor at clock cycle 9
        #1; // Delay to ensure output is stable
        $fdisplay(fd, "scenario: 10, zero = %d", zero);

        // Close the output file
        $fclose(fd);
        
        // End the simulation
        $finish;
    end

endmodule
