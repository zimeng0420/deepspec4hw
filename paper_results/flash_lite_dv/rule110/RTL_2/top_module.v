module top_module(
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        for (int i = 0; i < 512; i++) begin
            // Calculate next state based on Rule 110
            if (i == 0) begin
                next_q[i] = (q[i] & q[i+1]);
            end
            else if (i == 511) begin
                next_q[i] = (!q[i-1] & q[i]);
            end
            else begin
                next_q[i] = (q[i] & (q[i+1] | !q[i-1])) | (!q[i-1] & !q[i] & q[i+1]); // Simplified Rule 110 logic
            end
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