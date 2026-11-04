module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= q; // Hold the current value
        end else begin
            case (q)
                3'b100: q <= 3'b101; // 4 -> 5
                3'b101: q <= 3'b110; // 5 -> 6
                3'b110: q <= 3'b000; // 6 -> 0
                3'b000: q <= 3'b001; // 0 -> 1
                default: q <= q + 1; // increment by 1
            endcase
        end
    end

endmodule