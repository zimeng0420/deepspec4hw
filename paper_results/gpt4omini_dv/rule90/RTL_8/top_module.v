module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        next_q[0] = 0; // Boundary condition
        next_q[511] = 0; // Boundary condition
        for (integer i = 1; i < 511; i = i + 1) begin
            next_q[i] = q[i-1] ^ q[i+1]; // Rule 90 logic
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data; // Load state
        end else begin
            q <= next_q; // Update to next state
        end
    end

endmodule