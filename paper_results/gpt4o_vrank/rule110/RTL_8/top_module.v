module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q);

    reg [513:0] extended_q; // For handling boundaries

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            extended_q[512:1] <= q; // Load current state with boundaries
            extended_q[0] <= 1'b0;  // Left boundary
            extended_q[513] <= 1'b0; // Right boundary

            integer i;
            for (i = 0; i < 512; i = i + 1) begin
                // Apply Rule 110
                q[i] <= (extended_q[i+1] & (extended_q[i+2] ^ extended_q[i])) | 
                        (~extended_q[i+1] & extended_q[i+2]);
            end
        end
    end
endmodule