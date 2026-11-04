```verilog
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);
    always @(posedge clk) begin
        if (load) begin
            // Load data into the register
            q <= data;
        end else begin
            // Rotate logic
            case (ena)
                2'b01: begin
                    // Rotate right by one bit
                    q <= {q[0], q[99:1]};
                end
                2'b10: begin
                    // Rotate left by one bit
                    q <= {q[98:0], q[99]};
                end
                // 2'b00 and 2'b11 do nothing
                default: begin
                    q <= q; // Maintain previous state
                end
            endcase
        end
    end
endmodule
```