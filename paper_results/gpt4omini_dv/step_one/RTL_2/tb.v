`timescale 1ns / 1ps

module tb_top_module;

    // Instantiate the DUT
    wire one;
    top_module uut (
        .one(one)
    );

    // File descriptor
    integer fd;

    initial begin
        // Open the file to write the output
        fd = $fopen("TBout.txt", "w");

        // Delay and export the output at various time points
        #0; // scenario 1
        $fdisplay(fd, "scenario: 1, one = %d", one);

        #10; // scenario 2
        $fdisplay(fd, "scenario: 2, one = %d", one);

        #10; // scenario 3
        $fdisplay(fd, "scenario: 3, one = %d", one);

        #30; // scenario 4
        $fdisplay(fd, "scenario: 4, one = %d", one);

        #50; // scenario 5
        $fdisplay(fd, "scenario: 5, one = %d", one);

        #50; // scenario 6 
        #50; 
        $fdisplay(fd, "scenario: 6, one = %d", one);

        // Close the file
        $fclose(fd);
    end

endmodule
