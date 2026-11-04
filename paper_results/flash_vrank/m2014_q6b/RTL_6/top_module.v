module top_module(
    input [3:1] y,
    input w,
    output reg Y2);

    always @(*) begin
        case (y)
            3'b000: // A
                if (w == 0) Y2 = 0; 
                else Y2 = 0; // Stays in A (000)
            3'b001: // B
                if (w == 0) Y2 = 1; // Goes to C (010)
                else Y2 = 1; // Goes to D (011)
            3'b010: // C
                if (w == 0) Y2 = 1; // Goes to E (100)
                else Y2 = 1; // Goes to D (011)
            3'b011: // D
                if (w == 0) Y2 = 1; // Goes to F (101)
                else Y2 = 0; // Goes to A (000)
            3'b100: // E
                if (w == 0) Y2 = 1; // Stays in E (100)
                else Y2 = 1; // Goes to D (011)
            3'b101: // F
                if (w == 0) Y2 = 1; // Goes to C (010)
                else Y2 = 1; // Goes to D (011)
            default: Y2 = 0;
        endcase
    end

endmodule