module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data; // Load counter with input data
        end else if (counter != 0) begin
            counter <= counter - 1; // Decrement counter if not zero
        end
    end

    assign tc = (counter == 0); // tc is high when counter reaches 0

endmodule