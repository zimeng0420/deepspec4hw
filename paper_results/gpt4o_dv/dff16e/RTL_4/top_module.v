module top_module(
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q);

    always @(posedge clk) begin
        if (!resetn)
            q <= 16'b0; // Synchronous reset
        else begin
            if (byteena[0])
                q[7:0] <= d[7:0]; // Update lower byte if byteena[0] is high
            if (byteena[1])
                q[15:8] <= d[15:8]; // Update upper byte if byteena[1] is high
        end
    end

endmodule