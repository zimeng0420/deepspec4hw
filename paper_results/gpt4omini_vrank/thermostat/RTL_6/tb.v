`timescale 1ns / 1ps

module tb_top_module;

    // Parameters and Signals
    reg mode;
    reg too_cold;
    reg too_hot;
    reg fan_on;
    wire heater;
    wire aircon;
    wire fan;

    // Instantiate the DUT
    top_module dut (
        .mode(mode),
        .too_cold(too_cold),
        .too_hot(too_hot),
        .fan_on(fan_on),
        .heater(heater),
        .aircon(aircon),
        .fan(fan)
    );

    integer file;

    initial begin
        // Open the output file
        file = $fopen("TBout.txt", "w");

        // Scenario 1
        mode = 1; too_cold = 1; too_hot = 0; fan_on = 0;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 1, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 2
        mode = 1; too_cold = 0; too_hot = 0; fan_on = 0;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 2, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 3
        mode = 1; too_cold = 1; too_hot = 0; fan_on = 1;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 3, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 4
        mode = 1; too_cold = 0; too_hot = 0; fan_on = 1;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 4, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 5
        mode = 0; too_cold = 0; too_hot = 1; fan_on = 0;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 5, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 6
        mode = 0; too_cold = 0; too_hot = 0; fan_on = 0;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 6, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 7
        mode = 0; too_cold = 0; too_hot = 1; fan_on = 1; // Added missing condition
        #10; // Wait for stability
        $fdisplay(file, "scenario: 7, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 8
        mode = 0; too_cold = 0; too_hot = 0; fan_on = 1;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 8, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 9
        mode = 1; too_cold = 1; too_hot = 1; fan_on = 0;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 9, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 10
        mode = 0; too_cold = 1; too_hot = 1; fan_on = 0;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 10, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 11
        mode = 1; too_cold = 1; too_hot = 1; fan_on = 1;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 11, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 12
        mode = 0; too_cold = 1; too_hot = 1; fan_on = 1;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 12, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 13
        mode = 1; too_cold = 0; too_hot = 1; fan_on = 1;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 13, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Scenario 14
        mode = 0; too_cold = 1; too_hot = 0; fan_on = 1;
        #10; // Wait for stability
        $fdisplay(file, "scenario: 14, mode = %d, too_cold = %d, too_hot = %d, fan_on = %d, heater = %d, aircon = %d, fan = %d", mode, too_cold, too_hot, fan_on, heater, aircon, fan);

        // Close the file
        $fclose(file);
    end

endmodule
