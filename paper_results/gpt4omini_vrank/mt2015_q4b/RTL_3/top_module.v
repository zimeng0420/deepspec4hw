module top_module(
    input wire clk,
    output reg x,
    output reg y,
    output reg z
);
    initial begin
        // Initial states
        x = 0; 
        y = 0; 
        z = 1;

        // State transitions according to the given times
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