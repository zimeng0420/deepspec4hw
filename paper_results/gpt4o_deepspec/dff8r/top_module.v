module top_module(
    input clk,
    input [7:0] d,
    input reset,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) 
            q <= 8'b0; // Reset takes priority and sets q to 0
        else
            q <= d;    // Else, q takes the value of d
    end

endmodule