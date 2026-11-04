`timescale 1ns / 1ps

module tb_top_module;

// Inputs
reg [7:0] a;
reg [7:0] b;
reg [7:0] c;
reg [7:0] d;

// Outputs
wire [7:0] min;

// Instantiate the DUT
top_module dut (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .min(min)
);

integer file;

// Test scenarios
initial begin
    file = $fopen("TBout.txt", "w");
    if (file == 0) begin
        $display("Error opening file!");
        $finish;
    end

    // Scenario 1
    a = 8'h00; b = 8'h01; c = 8'h02; d = 8'h03;
    #10;
    $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 2
    a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF;
    #10;
    $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 3
    a = 8'h05; b = 8'h02; c = 8'h03; d = 8'h04;
    #10;
    $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 4
    a = 8'h10; b = 8'h20; c = 8'h00; d = 8'h0F;
    #10;
    $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 5
    a = 8'h7A; b = 8'h3C; c = 8'h7B; d = 8'h3A;
    #10;
    $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 6
    a = 8'hAA; b = 8'hBB; c = 8'hCC; d = 8'hDD;
    #10;
    $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 7
    a = 8'h01; b = 8'h00; c = 8'h01; d = 8'h01;
    #10;
    $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 8
    a = 8'h10; b = 8'h10; c = 8'h10; d = 8'h10;
    #10;
    $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 9
    a = 8'h99; b = 8'h00; c = 8'hFF; d = 8'h01;
    #10;
    $fdisplay(file, "scenario: 9, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    // Scenario 10
    a = 8'h7F; b = 8'h80; c = 8'h7E; d = 8'h81;
    #10;
    $fdisplay(file, "scenario: 10, a = %d, b = %d, c = %d, d = %d, min = %d", a, b, c, d, min);

    $fclose(file);
    $finish;
end

endmodule
