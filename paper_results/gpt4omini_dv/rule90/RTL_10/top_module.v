module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) 
            q <= data;
        else 
            q <= next_q;
    end

    always @* begin
        next_q[0] = 1'b0; // Left boundary condition
        next_q[511] = 1'b0; // Right boundary condition
        for (int i = 1; i < 511; i = i + 1) begin
            next_q[i] = q[i-1] ^ q[i+1]; // Rule 90 logic
        end
    end

endmodule