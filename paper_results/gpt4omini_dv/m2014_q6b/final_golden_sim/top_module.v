module top_module(
    input [3:1] y,
    input w,
    output reg Y2);

    always @(*) begin
        case (y)
            3'b000: // State A
                Y2 = (w == 0) ? 0 : 0; // Next state B or stay in A
            3'b001: // State B
                Y2 = (w == 0) ? 1 : 1; // Next state C or D
            3'b010: // State C
                Y2 = (w == 0) ? 0 : 1; // Next state E or D
            3'b011: // State D
                Y2 = (w == 0) ? 0 : 0; // Next state F or A
            3'b100: // State E
                Y2 = (w == 0) ? 0 : 1; // Stay in E or go to D
            3'b101: // State F
                Y2 = (w == 0) ? 1 : 1; // Next state C or D
            default: Y2 = 0; // Default state
        endcase
    end

endmodule