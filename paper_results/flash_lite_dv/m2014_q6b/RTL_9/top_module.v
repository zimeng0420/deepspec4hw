module top_module(
    input [3:1] y,
    input w,
    output reg Y2
);

    always @(*) begin
        case (y)
            3'b000: // State A
                Y2 = 1'b0; // A --0--> B, A --1--> A, y[2] remains 0
            3'b001: // State B
                Y2 = w; // B --0--> C, B --1--> D, y[2] = w
            3'b010: // State C
                Y2 = w; // C --0--> E, C --1--> D, y[2] = w
            3'b011: // State D
                Y2 = ~w; // D --0--> F, D --1--> A, y[2] = ~w
            3'b100: // State E
                Y2 = w; // E --0--> E, E --1--> D, y[2] = w
            3'b101: // State F
                Y2 = ~w; // F --0--> C, F --1--> D, y[2] = ~w
            default:
                Y2 = 1'b0; // Default to prevent latch
        endcase
    end

endmodule