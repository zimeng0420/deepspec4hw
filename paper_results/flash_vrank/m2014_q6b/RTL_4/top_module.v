module top_module(
    input [3:1] y,
    input w,
    output reg Y2);

    always @(*) begin
        case (y)
            3'b000:  // A
                if (w == 0) Y2 = 0;
                else        Y2 = 0;
            3'b001:  // B
                if (w == 0) Y2 = 1;
                else        Y2 = 1;
            3'b010:  // C
                if (w == 0) Y2 = 0;
                else        Y2 = 1;
            3'b011:  // D
                if (w == 0) Y2 = 1;
                else        Y2 = 0;
            3'b100:  // E
                if (w == 0) Y2 = 0;
                else        Y2 = 1;
            3'b101:  // F
                if (w == 0) Y2 = 1;
                else        Y2 = 1;
            default: Y2 = 0;
        endcase
    end

endmodule