module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load new value
            tc <= 0; // Reset terminal count when loading new value
        end else if (counter > 0) begin
            counter <= counter - 1; // Decrement
        end
        
        tc <= (counter == 0); // Terminal count signal
    end

endmodule