`timescale 1ns / 1ps
module testbench;
reg  clk;
reg  in;
reg  reset;
wire [7:0] out_byte;
wire  done;

integer file, scenario;
// DUT instantiation
top_module DUT (
	.clk(clk),
	.in(in),
	.reset(reset),
	.out_byte(out_byte),
	.done(done)
);
// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    file = $fopen("TBout.txt", "w");
end
// Scenario Based Test
initial begin

    // Scenario 1: Reset the DUT
    scenario = 1;
    reset = 1;
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    reset = 0;
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    // Scenario 2: Send a complete byte (0 00000001 1)
    scenario = 2;
    in = 0; // start bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    for (int i = 0; i < 8; i++) begin
        in = i[0]; // send data bits
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
        repeat(1) begin
            $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
        end
    end
    in = 1; // stop bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    // Scenario 3: Send the next byte (0 00000010 1)
    scenario = 3;
    in = 0; // start bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    in = 0; // data bits
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    in = 1; // next data bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    for (int i = 2; i < 8; i++) begin
        in = i[0]; // send remaining data bits
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
        repeat(1) begin
            $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
        end
    end
    in = 1; // stop bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    // Scenario 4: Send an invalid byte (0 11111111)
    scenario = 4;
    in = 0; // start bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    for (int i = 0; i < 8; i++) begin
        in = 1; // send 1s for data bits
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
        repeat(1) begin
            $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
        end
    end
    // omitting stop bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; // wait for 10 clock cycles
    in = 1; // stop bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    // Scenario 5: Send a complete byte (0 00001111 1)
    scenario = 5;
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; // wait for 5 clock cycles before sending
    in = 0; // start bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    in = 0; // data bits
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    in = 1; // next data bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    for (int i = 2; i < 8; i++) begin
        in = (i < 6) ? 1 : 0; // send the data bits (1111)
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
        repeat(1) begin
            $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
        end
    end
    in = 1; // stop bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    // Scenario 6: Send a complete byte (0 11110000 1) and idle state
    scenario = 6;
    in = 0; // start bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    for (int i = 0; i < 4; i++) begin
        in = (i < 4) ? 1 : 0; // send data bits (1111 followed by 0000)
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
        repeat(1) begin
            $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
        end
    end
    in = 1; // stop bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    // Idle state for 10 clock cycles
    for (int i = 0; i < 10; i++) begin
        in = 1; // idle (1)
        $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
        repeat(1) begin
            $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
        end
    end

    // Scenario 7: Trigger reset after sending two bytes
    scenario = 7;
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; // wait before reset
    reset = 1; // assert reset
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    reset = 0; // release reset
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    // Scenario 8: Send a start bit immediately followed by a stop bit (0 1)
    scenario = 8;
    in = 0; // start bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end
    in = 1; // stop bit
    $fdisplay(file, "scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10; 
    repeat(1) begin
        $fdisplay(file, "[check]scenario: %d, clk = %d, in = %d, reset = %d, out_byte = %d, done = %d", scenario, clk, in, reset, out_byte, done); #10;
    end

    $fclose(file);
    $finish;
end

endmodule
