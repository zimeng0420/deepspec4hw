module top_module(
    input wire clk,
    output reg x,
    output reg y,
    output reg z
);

    initial begin
        // Initialize outputs
        x = 0;
        y = 0;
        z = 1;

        // Generate the waveform
        #5  x = 0; y = 0; z = 1;
        #5  x = 0; y = 0; z = 1;
        #5  x = 0; y = 0; z = 1;
        #5  x = 0; y = 0; z = 1;
        #5  x = 0; y = 0; z = 1;
        #5  x = 1; y = 0; z = 0;
        #5  x = 1; y = 0; z = 0;
        #5  x = 0; y = 1; z = 0;
        #5  x = 0; y = 1; z = 0;
        #5  x = 1; y = 1; z = 1;
        #5  x = 1; y = 1; z = 1;
        #5  x = 0; y = 0; z = 1;
        #5  x = 0; y = 1; z = 0;
        #5  x = 0; y = 1; z = 0;
        #5  x = 1; y = 1; z = 1;
        #5  x = 0; y = 1; z = 0;
        #5  x = 0; y = 1; z = 0;
        #5  x = 0; y = 1; z = 0;
        #5  x = 1; y = 0; z = 0;
    end
endmodule