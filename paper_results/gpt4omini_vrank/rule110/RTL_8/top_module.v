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
        next_q[0] = 0; // Left boundary
        next_q[511] = 0; // Right boundary
        
        for (int i = 1; i < 511; i++) begin
            case ({q[i-1], q[i], q[i+1]})
                3'b111: next_q[i] = 0;
                3'b110: next_q[i] = 1;
                3'b101: next_q[i] = 1;
                3'b100: next_q[i] = 0;
                3'b011: next_q[i] = 1;
                3'b010: next_q[i] = 1;
                3'b001: next_q[i] = 1;
                3'b000: next_q[i] = 0;
                default: next_q[i] = 0; // Should never occur
            endcase
        end
        
        q <= next_q;
    end
end

endmodule