module top_module(
    input [3:1] y,
    input w,
    output reg Y2);

    always @(*) begin
        case (y)
            3'b000: Y2 = 0; // State A: y[2] is 0 regardless of 'w'
            3'b001: Y2 = (w == 0) ? 0 : 1; // State B: transition depending on 'w'
            3'b010: Y2 = 1; // State C: y[2] is 1 regardless of 'w'
            3'b011: Y2 = 1; // State D: y[2] is 1 regardless of 'w'
            3'b100: Y2 = 1; // State E: y[2] is 1 regardless of 'w'
            3'b101: Y2 = 0; // State F: y[2] is 0 regardless of 'w'
            default: Y2 = 0; // Default case
        endcase
    end

endmodule