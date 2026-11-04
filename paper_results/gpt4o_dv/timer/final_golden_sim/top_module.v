module top_module(
    input clk, 
    input load, 
    input [9:0] data, 
    output reg tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
            tc <= (data == 0);
        end
        else if (counter != 0) begin
            counter <= counter - 1'b1;
            tc <= (counter == 1); // tc will be 1 when counter reaches 1 and decrements to 0
        end
        else begin
            tc <= 1'b1; // Keep tc asserted once counter reaches 0
        end
    end

endmodule