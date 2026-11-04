`timescale 1ns / 1ps

module tb_top_module;

// Inputs
reg [6:1] y;
reg w;

// Outputs
wire Y2;
wire Y4;

// Instantiate the DUT
top_module uut (
    .y(y),
    .w(w),
    .Y2(Y2),
    .Y4(Y4)
);

integer file;

initial begin
    // Open file for writing
    file = $fopen("TBout.txt", "w");
    
    // Scenario 1: A (000001), w = 0
    y = 6'b000001; w = 0; #10; // Should trigger a transition from A to B
    $fdisplay(file, "scenario: 1, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 2: A (000001), w = 1
    y = 6'b000001; w = 1; #10; // Should maintain state A
    $fdisplay(file, "scenario: 2, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 3: B (000010), w = 0
    y = 6'b000010; w = 0; #10; // Should trigger a transition from B to C
    $fdisplay(file, "scenario: 3, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 4: B (000010), w = 1
    y = 6'b000010; w = 1; #10; // Should trigger a transition from B to D
    $fdisplay(file, "scenario: 4, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 5: C (000100), w = 0
    y = 6'b000100; w = 0; #10; // Should trigger a transition from C to E
    $fdisplay(file, "scenario: 5, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 6: C (000100), w = 1
    y = 6'b000100; w = 1; #10; // Should trigger a transition from C to D
    $fdisplay(file, "scenario: 6, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 7: D (001000), w = 0
    y = 6'b001000; w = 0; #10; // Should trigger a transition from D to F
    $fdisplay(file, "scenario: 7, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 8: D (001000), w = 1
    y = 6'b001000; w = 1; #10; // Should trigger a transition from D back to A
    $fdisplay(file, "scenario: 8, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 9: E (010000), w = 0
    y = 6'b010000; w = 0; #10; // Should maintain state E
    $fdisplay(file, "scenario: 9, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 10: E (010000), w = 1
    y = 6'b010000; w = 1; #10; // Should trigger a transition from E to D
    $fdisplay(file, "scenario: 10, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 11: F (100000), w = 0
    y = 6'b100000; w = 0; #10; // Should trigger a transition from F to C
    $fdisplay(file, "scenario: 11, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Scenario 12: F (100000), w = 1
    y = 6'b100000; w = 1; #10; // Should trigger a transition from F to D
    $fdisplay(file, "scenario: 12, y = %b, w = %b, Y2 = %b, Y4 = %b", y, w, Y2, Y4);
    
    // Close the file
    $fclose(file);
end

endmodule
