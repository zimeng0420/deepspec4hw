module top_module(
    input [2:0] y,
    input w,
    output reg Y2
);

    always @(*) begin
        case (y)
            3'b000:  // A
                Y2 = w ? 1'b0 : 1'b0; // A --1--> A, A --0--> B
            3'b001:  // B
                Y2 = w ? 1'b1 : 1'b0; // B --1--> D, B --0--> C
            3'b010:  // C
                Y2 = w ? 1'b1 : 1'b0; // C --1--> D, C --0--> E
            3'b011:  // D
                Y2 = w ? 1'b0 : 1'b0; // D --1--> A, D --0--> F
            3'b100:  // E
                Y2 = w ? 1'b1 : 1'b1; // E --1--> D, E --0--> E
            3'b101:  // F
                Y2 = w ? 1'b0 : 1'b0; // F --1--> D, F --0--> C
            default:
                Y2 = 1'b0; // Default state
        endcase
    end

endmodule