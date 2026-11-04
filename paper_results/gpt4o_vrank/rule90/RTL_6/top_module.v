module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q[0] <= q[1]; // Boundary condition q[-1] considered as 0.
            q[511] <= q[510]; // Boundary condition q[512] considered as 0.
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= q[i-1] ^ q[i+1];
            end
        end
    end

endmodule