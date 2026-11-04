module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);

// Internal counter declaration
reg [9:0] counter;

// Sequential logic for loading and decrementing the counter
always @(posedge clk) begin
    if (load) begin
        counter <= data; // Load new value
    end else if (counter > 0) begin
        counter <= counter - 1; // Decrement
    end
end

// Terminal count logic
always @(*) begin
    tc = (counter == 0); // Terminal count signal
end

endmodule