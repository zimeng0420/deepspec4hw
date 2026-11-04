module top_module(
	input clk,
	input load,
	input [511:0] data,
	output reg [511:0] q
);

    reg [511:0] next_q;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Calculate next state
            for (int i = 0; i < 512; i = i + 1) begin
                // Handle boundary conditions
                logic left = (i == 0) ? 1'b0 : q[i-1];
                logic center = q[i];
                logic right = (i == 511) ? 1'b0 : q[i+1];

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
                    default: next_q[i] = 1'b0; // Shouldn't happen, but handle for completeness
                endcase
            end
            q <= next_q;
        end
    end

endmodule