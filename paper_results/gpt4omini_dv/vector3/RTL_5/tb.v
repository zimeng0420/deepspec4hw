`timescale 1ns / 1ps

module tb_top_module;

// Declare inputs as 5-bit registers
reg [4:0] a;
reg [4:0] b;
reg [4:0] c;
reg [4:0] d;
reg [4:0] e;
reg [4:0] f;

// Declare outputs as 8-bit wires
wire [7:0] w;
wire [7:0] x;
wire [7:0] y;
wire [7:0] z;

// Instantiate the DUT
top_module DUT (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .e(e),
    .f(f),
    .w(w),
    .x(x),
    .y(y),
    .z(z)
);

// File variable for output
integer file;

// Initial block to perform test scenarios
initial begin
    // Open the output file
    file = $fopen("TBout.txt", "w");
    
    // Scenario 1: All zeros
    a = 5'b00000; b = 5'b00000; c = 5'b00000; d = 5'b00000; e = 5'b00000; f = 5'b00000;
    #1; // Wait for signals to stabilize
    $fdisplay(file, "scenario: 1, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);
    
    // Scenario 2: All ones
    a = 5'b11111; b = 5'b11111; c = 5'b11111; d = 5'b11111; e = 5'b11111; f = 5'b11111;
    #1;
    $fdisplay(file, "scenario: 2, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);
    
    // Scenario 3: Specific values
    a = 5'b00001; b = 5'b00010; c = 5'b00011; d = 5'b00100; e = 5'b00101; f = 5'b00110;
    #1;
    $fdisplay(file, "scenario: 3, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);
    
    // Scenario 4: All ones descending
    a = 5'b11111; b = 5'b11110; c = 5'b11101; d = 5'b11100; e = 5'b11011; f = 5'b11010;
    #1;
    $fdisplay(file, "scenario: 4, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);
    
    // Scenario 5: Mixed values
    a = 5'b01010; b = 5'b10101; c = 5'b00101; d = 5'b11010; e = 5'b11111; f = 5'b00000;
    #1;
    $fdisplay(file, "scenario: 5, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);
    
    // Scenario 6: Random values
    a = 5'b00000; b = 5'b11111; c = 5'b01010; d = 5'b10101; e = 5'b10000; f = 5'b01111;
    #1;
    $fdisplay(file, "scenario: 6, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);
    
    // Scenario 7: Random values
    a = 5'b00111; b = 5'b10001; c = 5'b01101; d = 5'b11010; e = 5'b00011; f = 5'b11100;
    #1;
    $fdisplay(file, "scenario: 7, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);

    // Scenario 8: Incrementing inputs
    for (integer i = 0; i < 32; i = i + 1) begin
        a = i % 32; b = (i + 1) % 32; c = (i + 2) % 32; d = (i + 3) % 32; e = (i + 4) % 32; f = (i + 5) % 32;
        #1;
        $fdisplay(file, "scenario: 8, a = %d, b = %d, c = %d, d = %d, e = %d, f = %d, w = %d, x = %d, y = %d, z = %d", a, b, c, d, e, f, w, x, y, z);
    end

    // Close the output file
    $fclose(file);
    
    // End simulation
    $finish;
end

endmodule
