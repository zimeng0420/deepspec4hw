module top_module(
    input [3:1] y,
    input w,
    output reg Y2
);

    always @(*) begin
        case (y)
            3'b000: begin // A
                Y2 = 1'b0; // A --0--> B, A --1--> A (y2 does not change)
            end
            3'b001: begin // B
                Y2 = 1'b0; // B --0--> C, B --1--> D (y2 does not change)
            end
            3'b010: begin // C
                Y2 = 1'b1; // C --0--> E, C --1--> D
            end
            3'b011: begin // D
                Y2 = w; // D --0--> F, D --1--> A
            end
            3'b100: begin // E
                Y2 = w; // E --0--> E, E --1--> D
            end
            3'b101: begin // F
                Y2 = 1'b0; // F --0--> C, F --1--> D (y2 does not change)
            end
            default: begin
                Y2 = 1'b0; // Default to state A (000)
            end
        endcase
    end

endmodule