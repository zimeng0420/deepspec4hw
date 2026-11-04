module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            // Rule 110 logic
            // Handle boundary conditions: q[-1] = 0 and q[512] = 0
            logic left  = (i == 0)   ? 1'b0 : q[i-1];
            logic center = q[i];
            logic right = (i == 511) ? 1'b0 : q[i+1];
            next_q[i] = (center & (right | ~left)) | (~left & ~center & right);
            // next_q[i] = (!left & center & right) | (!left & center & !right) | (!left & !center & right) | (left & center & !right); // alternate implementation
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule