`timescale 1ns / 1ps

module tb_top_module;

    // Inputs
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    reg [3:0] d;
    reg [3:0] e;

    // Outputs
    wire [3:0] q;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .e(e),
        .q(q)
    );

    // File pointer
    integer file;

    initial begin
        // Open the file for writing
        file = $fopen("TBout.txt", "w");

        // Test scenarios
        a = 4'hA; b = 4'hB; d = 4'hD; e = 4'hE; // Set a, b, d, e for all scenarios

        // Scenario 1
        #15 c = 4'h0; // Apply inputs at 15ns
        #1 $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);

        // Scenario 2
        #5 c = 4'h1; // Apply inputs at 20ns
        #1 $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 3
        #5 c = 4'h2; // Apply inputs at 25ns
        #1 $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 4
        #5 c = 4'h3; // Apply inputs at 30ns
        #1 $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 5
        #5 c = 4'h4; // Apply inputs at 35ns
        #1 $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 6
        #5 c = 4'h5; // Apply inputs at 40ns
        #1 $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 7
        #5 c = 4'h6; // Apply inputs at 45ns
        #1 $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 8
        #5 c = 4'h7; // Apply inputs at 50ns
        #1 $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 9
        #5 c = 4'h8; // Apply inputs at 55ns
        #1 $fdisplay(file, "scenario: 9, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 10
        #5 c = 4'h9; // Apply inputs at 60ns
        #1 $fdisplay(file, "scenario: 10, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 11
        #5 c = 4'hA; // Apply inputs at 65ns
        #1 $fdisplay(file, "scenario: 11, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 12
        #5 c = 4'hB; // Apply inputs at 70ns
        #1 $fdisplay(file, "scenario: 12, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 13
        #5 c = 4'hC; // Apply inputs at 75ns
        #1 $fdisplay(file, "scenario: 13, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 14
        #5 c = 4'hD; // Apply inputs at 80ns
        #1 $fdisplay(file, "scenario: 14, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 15
        #5 c = 4'hE; // Apply inputs at 85ns
        #1 $fdisplay(file, "scenario: 15, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);
        
        // Scenario 16
        #5 c = 4'hF; // Apply inputs at 90ns
        #1 $fdisplay(file, "scenario: 16, a = %d, b = %d, c = %d, d = %d, e = %d, q = %d", a, b, c, d, e, q);

        // Close the file
        $fclose(file);
        $finish;
    end

endmodule
