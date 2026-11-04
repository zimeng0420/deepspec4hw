module top_module(
    input [3:1] y,
    input w,
    output reg Y2);

    always @(*) begin
        case (y)
            3'b000:  // A
                if (w == 0)
                    Y2 = 0; // B
                else
                    Y2 = 0; // A
            3'b001:  // B
                if (w == 0)
                    Y2 = 1; // C
                else
                    Y2 = 1; // D
            3'b010:  // C
                if (w == 0)
                    Y2 = 0; // E
                else
                    Y2 = 1; // D
            3'b011:  // D
                if (w == 0)
                    Y2 = 1; // F
                else
                    Y2 = 0; // A
            3'b100:  // E
                if (w == 0)
                    Y2 = 0; // E
                else
                    Y2 = 1; // D
            3'b101:  // F
                if (w == 0)
                    Y2 = 1; // C
                else
                    Y2 = 1; // D
            default: Y2 = 0; // Should not happen, but good practice
        endcase
    end

endmodule