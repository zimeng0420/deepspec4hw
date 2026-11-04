module top_module (
    input clk,
    input a,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= q;
        end else begin
            case (q)
                3'b100: q <= 3'b101;
                3'b101: q <= 3'b110;
                3'b110: q <= 3'b000;
                3'b000: q <= 3'b001;
                default: q <= q + 1; //Handles states 0,1,2,3,7
            endcase
        end
    end

endmodule