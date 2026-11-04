module top_module(
    input [3:1] y,
    input w,
    output reg Y2);

    always @(*) begin
        case (y)
            3'b000: // State A
                if (w == 0)
                    Y2 = 0; // Next state B
                else
                    Y2 = 0; // Next state A
            3'b001: // State B
                if (w == 0)
                    Y2 = 1; // Next state C
                else
                    Y2 = 1; // Next state D
            3'b010: // State C
                if (w == 0)
                    Y2 = 0; // Next state E
                else
                    Y2 = 1; // Next state D
            3'b011: // State D
                if (w == 0)
                    Y2 = 0; // Next state F
                else
                    Y2 = 0; // Next state A
            3'b100: // State E
                if (w == 0)
                    Y2 = 0; // Next state E
                else
                    Y2 = 1; // Next state D
            3'b101: // State F
                if (w == 0)
                    Y2 = 1; // Next state C
                else
                    Y2 = 1; // Next state D
            default: Y2 = 0; // Default state
        endcase
    end

endmodule