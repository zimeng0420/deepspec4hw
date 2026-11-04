module top_module(
	input clk,
	input [7:0] in,
	output reg [7:0] pedge
);

    reg [7:0] in_prev;
    reg [7:0] pedge_internal;

    always @(posedge clk) begin
        // Store the previous value of the input
        in_prev <= in;

        // Edge detection and set pedge_internal
        for (integer i = 0; i < 8; i = i + 1) begin
            if (in[i] && !in_prev[i]) begin // Positive edge detected
                pedge_internal[i] <= 1'b1;
            end
        end

        // Update output and reset internal register
        pedge <= pedge_internal;
        pedge_internal <= 8'b0;
    end

endmodule