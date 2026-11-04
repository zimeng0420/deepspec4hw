module top_module(
    input [3:1] y,
    input w,
    output reg Y2);

    always @(*) begin
        case (y)
            3'b000: // A
                if (w == 0) begin
                    Y2 = 0; // B
                end else begin
                    Y2 = 0; // A
                end
            3'b001: // B
                if (w == 0) begin
                    Y2 = 1; // C
                end else begin
                    Y2 = 1; // D
                end
            3'b010: // C
                if (w == 0) begin
                    Y2 = 0; // E
                end else begin
                    Y2 = 1; // D
                end
            3'b011: // D
                if (w == 0) begin
                    Y2 = 1; // F
                end else begin
                    Y2 = 0; // A
                end
            3'b100: // E
                if (w == 0) begin
                    Y2 = 0; // E
                end else begin
                    Y2 = 1; // D
                end
            3'b101: // F
                if (w == 0) begin
                    Y2 = 1; // C
                end else begin
                    Y2 = 1; // D
                end
            default: Y2 = 0; // Avoid latch
        endcase
    end

endmodule