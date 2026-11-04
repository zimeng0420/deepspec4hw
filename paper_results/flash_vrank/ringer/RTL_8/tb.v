`timescale 1ns / 1ps

module tb_top_module;

    reg ring;
    reg vibrate_mode;
    wire ringer;
    wire motor;

    // Instantiate the DUT
    top_module uut (
        .ring(ring),
        .vibrate_mode(vibrate_mode),
        .ringer(ringer),
        .motor(motor)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1: vibrate_mode = 1, ring = 0
        vibrate_mode = 1; ring = 0;
        #1;
        $fdisplay(file, "scenario: 1, ring = %d, vibrate_mode = %d, ringer = %d, motor = %d", ring, vibrate_mode, ringer, motor);

        // Scenario 2: vibrate_mode = 0, ring = 1
        vibrate_mode = 0; ring = 1;
        #1;
        $fdisplay(file, "scenario: 2, ring = %d, vibrate_mode = %d, ringer = %d, motor = %d", ring, vibrate_mode, ringer, motor);

        // Scenario 3: vibrate_mode = 0, ring = 0
        vibrate_mode = 0; ring = 0;
        #1;
        $fdisplay(file, "scenario: 3, ring = %d, vibrate_mode = %d, ringer = %d, motor = %d", ring, vibrate_mode, ringer, motor);

        // Scenario 4: vibrate_mode = 1, ring = 1
        vibrate_mode = 1; ring = 1;
        #1;
        $fdisplay(file, "scenario: 4, ring = %d, vibrate_mode = %d, ringer = %d, motor = %d", ring, vibrate_mode, ringer, motor);

        // Close the output file
        $fclose(file);
        $finish;
    end

endmodule
