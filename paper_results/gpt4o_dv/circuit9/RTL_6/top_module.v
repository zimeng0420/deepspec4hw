module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a)
            q <= 3'b100; // Set q to 4
        else
            q <= q + 1; // Increment q
    end

endmodule