module top_module(
    input [3:1] y,
    input w,
    output reg Y2
);

always @(*) begin
    case (y)
        3'b000: Y2 = (w) ? 0 : 0; // A (0)
        3'b001: Y2 = (w) ? 1 : 0; // B (0)
        3'b010: Y2 = (w) ? 1 : 0; // C (0)
        3'b011: Y2 = (w) ? 1 : 0; // D (0)
        3'b100: Y2 = (w) ? 1 : 1; // E (1)
        3'b101: Y2 = (w) ? 1 : 0; // F (1)
        default: Y2 = 0; // Default case
    endcase
end

endmodule