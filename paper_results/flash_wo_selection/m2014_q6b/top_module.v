module top_module(
    input [3:1] y,
    input w,
    output reg Y2
);

    always @(*) begin
        if ((y == 3'b010 && w == 1'b0) || (y == 3'b011 && w == 1'b0) || (y == 3'b100)) begin
            Y2 = 1'b1;
        end else begin
            Y2 = 1'b0;
        end
    end

endmodule