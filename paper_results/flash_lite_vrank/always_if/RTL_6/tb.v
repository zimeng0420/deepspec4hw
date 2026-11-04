`timescale 1ns / 1ps

module tb_top_module;
    
    // Input signals
    reg a;
    reg b;
    reg sel_b1;
    reg sel_b2;
    
    // Output signals
    wire out_assign;
    wire out_always;

    // Instantiate the DUT
    top_module DUT (
        .a(a),
        .b(b),
        .sel_b1(sel_b1),
        .sel_b2(sel_b2),
        .out_assign(out_assign),
        .out_always(out_always)
    );

    // File descriptor for output
    integer fd;

    initial begin
        // Open file for writing
        fd = $fopen("TBout.txt", "w");
        
        // Scenario 1
        a = 0; b = 0; sel_b1 = 0; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 1, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 2
        a = 0; b = 0; sel_b1 = 0; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 2, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 3
        a = 0; b = 1; sel_b1 = 0; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 3, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 4
        a = 0; b = 1; sel_b1 = 0; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 4, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 5
        a = 1; b = 0; sel_b1 = 0; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 5, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 6
        a = 1; b = 0; sel_b1 = 0; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 6, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 7
        a = 1; b = 1; sel_b1 = 0; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 7, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 8
        a = 1; b = 1; sel_b1 = 0; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 8, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 9
        a = 0; b = 0; sel_b1 = 1; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 9, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 10
        a = 0; b = 1; sel_b1 = 1; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 10, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 11
        a = 1; b = 0; sel_b1 = 1; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 11, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 12
        a = 1; b = 1; sel_b1 = 1; sel_b2 = 0; #1;
        $fdisplay(fd, "scenario: 12, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 13
        a = 0; b = 0; sel_b1 = 1; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 13, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 14
        a = 0; b = 1; sel_b1 = 1; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 14, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 15
        a = 1; b = 0; sel_b1 = 1; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 15, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Scenario 16
        a = 1; b = 1; sel_b1 = 1; sel_b2 = 1; #1;
        $fdisplay(fd, "scenario: 16, a = %d, b = %d, sel_b1 = %d, sel_b2 = %d, out_assign = %d, out_always = %d", a, b, sel_b1, sel_b2, out_assign, out_always);
        
        // Close file
        $fclose(fd);
        
        // End simulation
        $finish;
    end
endmodule
