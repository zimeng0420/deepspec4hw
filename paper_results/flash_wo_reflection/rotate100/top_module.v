module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            case (ena)
                2'b01: begin // Rotate Right
                    q[0] <= q[99];
                    for (int i = 1; i < 100; i = i + 1) begin
                        q[i] <= q[i - 1];
                    end
                end
                2'b10: begin // Rotate Left
                    q[99] <= q[0];
                    for (int i = 0; i < 99; i = i + 1) begin
                        q[i] <= q[i + 1];
                    end
                end
                default: begin // No Rotation
                    //q <= q; // Redundant, but clarifies intent
                end
            endcase
        end
    end

endmodule