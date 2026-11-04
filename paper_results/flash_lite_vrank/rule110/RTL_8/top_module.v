module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q);

    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

    always @(*) begin
        integer i;
        for (i = 0; i < 512; i = i + 1) begin
            // Determine neighbors, handling boundary conditions
            logic left  = (i > 0) ? q[i-1] : 1'b0;
            logic center = q[i];
            logic right = (i < 511) ? q[i+1] : 1'b0;

            // Apply Rule 110
            case ({left, center, right})
                3'b111: next_q[i] = 1'b0;
                3'b110: next_q[i] = 1'b1;
                3'b101: next_q[i] = 1'b1;
                3'b100: next_q[i] = 1'b0;
                3'b011: next_q[i] = 1'b1;
                3'b010: next_q[i] = 1'b1;
                3'b001: next_q[i] = 1'b1;
                3'b000: next_q[i] = 1'b0;
                default: next_q[i] = 1'b0; // should never happen
            endcase
        end
    end

endmodule